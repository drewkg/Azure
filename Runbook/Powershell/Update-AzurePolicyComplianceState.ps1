<#
  .SYNOPSIS
  Update Azure PowerShell modules in an Azure Automation account.

  .DESCRIPTION
  This Azure Automation runbook updates Azure PowerShell modules imported into an
  Azure Automation account with the module versions published to the PowerShell Gallery.

  Prerequisite: an Azure Automation account with an Azure Run As account credential.

  .PARAMETER ResourceGroupName
  The Azure resource group name.

  .PARAMETER AutomationAccountName
  The Azure Automation account name.

  .PARAMETER AzureModuleClass
  (Optional) The class of module that will be updated (AzureRM or Az)
  If set to Az, this script will rely on only Az modules to update other modules.
  Set this to Az if your runbooks use only Az modules to avoid conflicts.

  .PARAMETER AzureEnvironment
  (Optional) Azure environment name.

  .PARAMETER Login
  (Optional) If $false, do not login to Azure.
#>

#Requires -Modules @{ ModuleName="AZ.ResourceGraph"; ModuleVersion="0.2.0" }

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param(
  [Parameter(Mandatory = $true)]
  [string] $ResourceGroupName,

  [Parameter(Mandatory = $true)]
  [string] $LogAnalyticsWorkspace,

  [Parameter(Mandatory = $true)]
  [string] $RootManagementGroup,

  [string] $AzureEnvironment = 'AzureCloud',

  [bool] $Login = $true
)

$ErrorActionPreference = "Continue"

function Login-AzureAutomation() {
  try {
    $RunAsConnection = Get-AutomationConnection -Name "AzureRunAsConnection"

    if (!$RunAsConnection) {
      Write-Output "Invalid or missing RunAs connection, attempting access using a MSI."
      Write-Output "Logging in to Azure ($AzureEnvironment)."

      # Ensures you do not inherit an AzContext in your runbook
      Disable-AzContextAutosave -Scope Process

      # Connect to Azure with system-assigned managed identity
      $AzureContext = (Connect-AzAccount -Identity).context

      # set and store context
      $AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
      Select-AzSubscription -SubscriptionId $AzureContext.Subscription | Write-Verbose
    } else {
      Write-Output "Attempting access using RunAs account."
      Write-Output "Logging in to Azure ($AzureEnvironment)."

      if (!$RunAsConnection.ApplicationId) {
        $ErrorMessage = "Connection 'AzureRunAsConnection' is incompatible type."
        throw $ErrorMessage
      }

      Connect-AzAccount `
          -ServicePrincipal `
          -TenantId $RunAsConnection.TenantId `
          -ApplicationId $RunAsConnection.ApplicationId `
          -CertificateThumbprint $RunAsConnection.CertificateThumbprint `
          -Environment $AzureEnvironment

      Select-AzSubscription -SubscriptionId $RunAsConnection.SubscriptionID  | Write-Verbose

      # Ensures you do not inherit an AzContext in your runbook
      Disable-AzContextAutosave -Scope Process
    }
  } catch {
    Write-Error $_.Exception
    throw $_.Exception
  }
}

if ($Login) {
  Login-AzureAutomation
}

Write-Output "Querying Azure Resource Graph for Policy State"

$KustoQuery = "
policyresources
| extend AssignmentScope = tostring(parse_json(properties).policyAssignmentScope),
         AssignmentName = tostring(parse_json(properties).policyAssignmentName)
| where ['kind'] =='policystates'
| summarize TotalResource = count(),
            NotCompliant = countif(parse_json(properties).complianceState != 'Compliant')
                by AssignmentName, AssignmentScope, subscriptionId
| order by AssignmentName asc, subscriptionId asc
"

$json = Search-AzGraph -Query $KustoQuery -ManagementGroup $RootManagementGroup | ConvertTo-Json

$workspace = Get-AzOperationalInsightsWorkspace -Name $LogAnalyticsWorkspace -ResourceGroupName $ResourceGroupName
$keys = $workspace | Get-AzOperationalInsightsWorkspaceSharedKey

# Replace with your Workspace ID
$CustomerId = $workspace.CustomerId

# Replace with your Primary Key
$SharedKey = $keys.PrimarySharedKey

# Specify the name of the record type that you'll be creating
$LogType = "PolicyComplianceState"

# You can use an optional field to specify the timestamp from the data. If the time field is not specified, Azure Monitor assumes the time is the message ingestion time
$TimeStampField = (Get-Date).ToUniversalTime()

# Create the function to create the authorization signature
Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource)
{
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId,$encodedHash
    return $authorization
}

# Create the function to create and post the request
Function Post-LogAnalyticsData($customerId, $sharedKey, $body, $logType)
{
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -customerId $customerId `
        -sharedKey $sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

    $headers = @{
        "Authorization" = $signature;
        "Log-Type" = $logType;
        "x-ms-date" = $rfc1123date;
        "time-generated-field" = $TimeStampField;
    }

    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
    return $response.StatusCode
}

# Submit the data to the API endpoint
Post-LogAnalyticsData -customerId $customerId -sharedKey $sharedKey -body ([System.Text.Encoding]::UTF8.GetBytes($json)) -logType $logType
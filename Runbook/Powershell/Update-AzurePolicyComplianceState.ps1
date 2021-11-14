<#
  Copyright (c) Microsoft Corporation. All rights reserved.
  Licensed under the MIT License.
#>

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

  .PARAMETER AzureEnvironment
  (Optional) Azure environment name.

  .PARAMETER Login
  (Optional) If $false, do not login to Azure.
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param(
  #[Parameter(Mandatory = $true)]
  [string] $ResourceGroupName,

  #[Parameter(Mandatory = $true)]
  [string] $AutomationAccountName,

  [string] $AzureEnvironment = 'AzureCloud',

  [bool] $Login = $true
)

$ErrorActionPreference = "Continue"

function Login-AzureAutomation([bool] $AzModuleOnly) {
  try {
    $RunAsConnection = Get-AutomationConnection -Name "AzureRunAsConnection"

    if (!$RunAsConnection) {
      Write-Output "Invalid or missing RunAs connection, attempting access using a MSI."
      if ($AzModuleOnly) {
        # Ensures you do not inherit an AzContext in your runbook
        Disable-AzContextAutosave -Scope Process

        # Connect to Azure with system-assigned managed identity
        $AzureContext = (Connect-AzAccount -Identity).context

        # set and store context
        $AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
        Select-AzSubscription -SubscriptionId $AzureContext.Subscription  | Write-Verbose
      } else {
        $AzureContext = (Connect-AzureRMAccount -Identity).context
        Select-AzureRmSubscription -SubscriptionId $AzureContext.Subscription | Write-Verbose
      }
    } else {
      Write-Output "Attempting access using RunAs account."
      Write-Output "Logging in to Azure ($AzureEnvironment)."

      if (!$RunAsConnection.ApplicationId) {
        $ErrorMessage = "Connection 'AzureRunAsConnection' is incompatible type."
        throw $ErrorMessage
      }

      if ($AzModuleOnly) {
        Connect-AzAccount `
            -ServicePrincipal `
            -TenantId $RunAsConnection.TenantId `
            -ApplicationId $RunAsConnection.ApplicationId `
            -CertificateThumbprint $RunAsConnection.CertificateThumbprint `
            -Environment $AzureEnvironment

        Select-AzSubscription -SubscriptionId $RunAsConnection.SubscriptionID  | Write-Verbose

        # Ensures you do not inherit an AzContext in your runbook
        Disable-AzContextAutosave -Scope Process
      } else {
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $RunAsConnection.TenantId `
            -ApplicationId $RunAsConnection.ApplicationId `
            -CertificateThumbprint $RunAsConnection.CertificateThumbprint `
            -Environment $AzureEnvironment

        Select-AzureRmSubscription -SubscriptionId $RunAsConnection.SubscriptionID  | Write-Verbose
      }
    }

  } catch {
    #if (!$RunAsConnection) {
    #  $RunAsConnection | fl | Write-Output
      Write-Output $_.Exception
    #  $ErrorMessage = "Connection 'AzureRunAsConnection' not found."
    #  throw $ErrorMessage
    #}

    throw $_.Exception
  }
}

if ($Login) {
  Login-AzureAutomation $UseAzModule
}

Write-Output "Querying Azure Resource Graph for Policy State"

$KustoQuery = "
policyresources
| extend AssignmentScope = parse_json(properties).policyAssignmentScope
| extend AssignmentName = tostring(parse_json(properties).policyAssignmentName)
| where ['kind'] =='policystates'
| summarize TotalResource = count(),
    NotCompliant = countif(parse_json(properties).complianceState != 'Compliant')
        by tostring(AssignmentName),
        tostring(AssignmentScope),
        subscriptionId
 | order by tostring(AssignmentName) asc
"
$result = Search-AzGraph -Query $KustoQuery -ManagementGroup 4b1b011c-6812-45a0-8112-f41550d0f0c9 | Formet-Table
Write-Output $result
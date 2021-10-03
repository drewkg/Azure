param (
  [switch]
  [parameter(ParameterSetName="MGSet")]
  $ManagementGroup,
  [switch]
  [parameter(ParameterSetName="SubSet")]
  $Subscription,
  [switch]
  [parameter(ParameterSetName="RGSet")]
  $ResourceGroup,
  [string]
  [Parameter(ParameterSetName="MGSet")]
  $ManagemengGroupId = "f0c0d850-482c-559b-82b2-b005c0aa2e7a",
  [string]
  [Parameter(ParameterSetName="SubSet")]
  $SubscriptionName = "f0c0d850-482c-559b-82b2-b005c0aa2e7a",
  [string]
  $ARMFile = ".\ARM\Policy\DiagnosticSettings\LogAnalytics\azureDeploy.json",
  [string]
  $ARMTemplate = ".\ARM\Policy\DiagnosticSettings\LogAnalytics\azuredeploy.parameters.json",
  [string]
  $BicepFile = ".\Bicep\Policy\DiagnosticSettings\LogAnalytics\main.bicep",
  [string]
  $BicepTemplate = ""
)

$BicepHashArguments = @{
  TemplateFile = $BicepFile
}

If ($BicepTemplate -ne "") { $BicepHashArguments.Add("TemplateParameterFile", $BicepTemplate) }

$ARMHashArguments = @{
  TemplateFile = $ARMFile
}

If ($ARMHashArguments -ne "") { $ARMHashArguments.Add("TemplateParameterFile", $ARMTemplate) }

switch ( $true )
{
  $ManagementGroup
  {
    $bicepWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth @BicepHashArguments
    $armWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth @ARMHashArguments
  }
  $Subscription
  {
    $bicepWhatIfResult = Get-AzSubscriptionDeploymentWhatIfResult -Name $SubscriptionName -Location UKSouth @BicepHashArguments
    $armWhatIfResult = Get-AzSubscriptionDeploymentWhatIfResult -Name $SubscriptionName -Location UKSouth @ARMHashArguments
  }
  $ResourceGroup
  {
    $bicepWhatIfResult = Get-AzResourceGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth @BicepHashArguments
    $armWhatIfResult = Get-AzResourceGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth @ARMHashArguments
  }
}

$armNoChanges = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'NoChange'}
$bicepNoChanges = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'NoChange'}

If ($armNoChanges.Count -eq $bicepNoChanges.Count) {
  Write-Host "Number of items with no change is the same"
} Else {
  ForEach ($item in $armNoChanges) {
    if ($($bicepNoChanges | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the ARM template, but not in the Bicep file."
    }
  }
  ForEach ($item in $bicepNoChanges) {
    if ($($armNoChanges | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the Bicep file, but not in the ARM template."
    }
  }
}

$armCreate = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Create'}
$bicepCreate = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Create'}

If ($armCreate.Count -eq $bicepCreate.Count) {
  Write-Host "Number of items modified is the same"
} Else {
  ForEach ($item in $armCreate) {
    if ($($bicepCreate | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the ARM template, but not in the Bicep file."
    }
  }
  ForEach ($item in $bicepCreate) {
    if ($($armCreate | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the Bicep file, but not in the ARM template."
    }
  }
}

$armModifications = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Modify'}
$bicepModification = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Modify'}

If ($armModifications.Count -eq $bicepModification.Count) {
  Write-Host "Number of items modified is the same"
} Else {
  ForEach ($item in $armModifications) {
    if ($($bicepModification | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the ARM template, but not in the Bicep file."
    }
  }
  ForEach ($item in $bicepModification) {
    if ($($armModifications | Where-Object {$_.RelativeResourceId -eq $item.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $item.RelativeResourceId "is created in the Bicep file, but not in the ARM template."
    }
  }
}

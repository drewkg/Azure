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
  $ARMTemplate,
  [string]
  $BicepFile
)

switch ( $true )
{
  $ManagementGroup
  {
    $bicepWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth -TemplateFile .\Bicep\Policy\DiagnosticSettings\LogAnalytics\main.bicep
    $armWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth -TemplateFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azureDeploy.json -TemplateParameterFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azuredeploy.parameters.json
  }
  $Subscription
  {
    $bicepWhatIfResult = Get-AzSubscriptionDeploymentWhatIfResult -Name $SubscriptionName -Location UKSouth -TemplateFile .\Bicep\Policy\DiagnosticSettings\LogAnalytics\main.bicep
    $armWhatIfResult = Get-AzSubscriptionDeploymentWhatIfResult -Name $SubscriptionName -Location UKSouth -TemplateFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azureDeploy.json -TemplateParameterFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azuredeploy.parameters.json
  }
  $ResourceGroup
  {
    $bicepWhatIfResult = Get-AzResourceGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth -TemplateFile .\Bicep\Policy\DiagnosticSettings\LogAnalytics\main.bicep
    $armWhatIfResult = Get-AzResourceGroupDeploymentWhatIfResult -ManagementGroupId $ManagemengGroupId -Location UKSouth -TemplateFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azureDeploy.json -TemplateParameterFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azuredeploy.parameters.json
  }
}

$armNoChanges = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'NoChange'}
$bicepNoChanges = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'NoChange'}

If ($armNoChanges.Count -eq $bicepNoChanges.Count) {
  Write-Host "Number of items with no change is the same"
} Else {
  $armNoChanges | ForEach-Object {
    $itemtofind = $_.RelativeResourceId

    $found = $bicepNoChanges | Where-Object {$_.RelativeResourceId -eq $itemtofind} | Measure-Object

    if ($found.Count -eq 0) {
      Write-Host $itemtofind "is unchanged in the ARM template, but not in the Bicep file."
    }
  }
}

$armCreate = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Create'}
$bicepCreate = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Create'}

If ($armCreate.Count -eq $bicepCreate.Count) {
  Write-Host "Number of items modified is the same"
} Else {
  ForEach ($createdItem in $armCreate) {
    if ($($bicepCreate | Where-Object {$_.RelativeResourceId -eq $createdItem.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $createdItem.RelativeResourceId "is created in the ARM template, but not in the Bicep file."
    }
  }
  ForEach ($createdItem in $bicepCreate) {
    if ($($armCreate | Where-Object {$_.RelativeResourceId -eq $createdItem.RelativeResourceId} | Measure-Object).Count -eq 0) {
      Write-Host $createdItem.RelativeResourceId "is created in the Bicep file, but not in the ARM template."
    }
  }
}

$armModifications = $armWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Modify'}
$bicepModification = $bicepWhatIfResult.Changes | Where-Object {$_.ChangeType -eq 'Modify'}

If ($armModifications.Count -eq $bicepModification.Count) {
  Write-Host "Number of items modified is the same"
} Else {
  $armModifications | ForEach-Object {
    $itemtofind = $_.RelativeResourceId

    $found = $bicepModification | Where-Object {$_.RelativeResourceId -eq $itemtofind} | Measure-Object

    if ($found.Count -eq 0) {
      Write-Host $itemtofind "is changed in the ARM template, but not in the Bicep file."
    }
  }
}

param (
  [switch]
  [parameter(ParameterSetName="MGSet")]
  $ManagementGroup,
  [switch]
  [parameter(ParameterSetName="SubSet")]
  $Subscription,
  [switch]
  [parameter(ParameterSetName="RGSet")]
  $ResourceGroup
)


$bicepWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId f0c0d850-482c-559b-82b2-b005c0aa2e7a -Location UKSouth -TemplateFile .\Bicep\Policy\DiagnosticSettings\LogAnalytics\main.bicep
$armWhatIfResult = Get-AzManagementGroupDeploymentWhatIfResult -ManagementGroupId f0c0d850-482c-559b-82b2-b005c0aa2e7a -Location UKSouth -TemplateFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azureDeploy.json -TemplateParameterFile .\ARM\Policy\DiagnosticSettings\LogAnalytics\azuredeploy.parameters.json


#Write-Host $bicepWhatIfResult.Changes.Count


#$bicepWhatIfResult.Changes | Select-Object -Unique | Where-Object { $armWhatIfResult.Changes -notcontains $_ }
$diff = Compare-Object -ReferenceObject $armWhatIfResult.Changes -DifferenceObject $bicepWhatIfResult.Changes

$diff
#$armWhatIfResult.Changes | Select-Object -Unique | Where-Object { $bicepWhatIfResult.Changes -notcontains $_ }

#$bicepWhatIfResult.Changes | ForEach-Object { Write-Host $_.FullyQualifiedResourceId }
#Write-Host $armWhatIfResult.Changes.Count

#$armWhatIfResult.Changes | ForEach-Object { Write-Host $_.FullyQualifiedResourceId }

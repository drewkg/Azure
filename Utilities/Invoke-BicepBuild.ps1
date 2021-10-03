param (
  [string] $outputPath = ".\Build",
  [array] $Exclusions = "AppServiceWithMSIAppInsights|LogAnalytics&AutomationAccount"
)

New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
Get-ChildItem -Path .\Bicep\ -Include main.bicep -Recurse -File
| Where-Object {$_.Directory -notmatch $Exclusions}
| ForEach-Object {
  Write-Host "Running bicep build on Directory - " $_.Directory
  New-Item -Path (Join-Path -Path $outputPath -ChildPath $_.Directory.Name) -ItemType Directory -Force | Out-Null
  bicep build $_.FullName --outdir (Join-Path -Path $outputPath -ChildPath $_.Directory.Name)
}
Remove-Item -Path $outputPath -Recurse
param (
  [string] $outputPath = "."
)

$ARMTTK_Releases = Invoke-RestMethod -Uri https://api.github.com/repos/Azure/arm-ttk/releases -Method Get

New-Item -Path ".\ARM-TTK" -ItemType Directory -Force
# The commented line below will always get the latest version, currently the script attempts to detect the latest version, this detection may prove to be incorrect
# Invoke-WebRequest -Uri "https://aka.ms/arm-ttk-latest" -OutFile "$(Build.ArtifactStagingDirectory)\ARM-TTK.zip"

Invoke-WebRequest -Uri $ARMTTK_Releases[0].assets.browser_download_url -OutFile ".\ARM-TTK\ARM-TTK.zip"
Expand-Archive -Path ".\ARM-TTK\ARM-TTK.zip" -DestinationPath ".\ARM-TTK" -Force

Import-Module ".\ARM-TTK\arm-ttk\arm-ttk.psd1" -Force
Import-Module -Name Pester -MaximumVersion 4.10.1
Set-Location "."
Get-ChildItem -Name arm-ttk-tests.ps1 -recurse -Path . | ForEach-Object {
  Write-Host "Running ARM-TTK on Directory - " $_.Split('\')[$_.Split('\').Count - 2]
  Invoke-Pester -Script (Join-Path -Path ".\" -ChildPath $_) -OutputFile (Join-Path -Path $outputPath -ChildPath ($_.Split('\')[$_.Split('\').Count - 2] + ".nunit")) -OutputFormat NUnitXml
}

Remove-Item ".\ARM-TTK" -Recurse

param (
  [string] $outputPath = ".\ARM-TTK"
)

$ARMTTK_Releases = Invoke-RestMethod -Uri https://api.github.com/repos/Azure/arm-ttk/releases -Method Get
$ARMTTK_DownloadLocation = $ARMTTK_Releases[0].assets.browser_download_url

Write-Host "Using ARM TTK Version -" $ARMTTK_Releases[0].name

# The commented line below will always get the latest version, currently the script attempts to detect the latest version, this detection may prove to be incorrect
# $ARMTTK_DownloadLocation = "https://aka.ms/arm-ttk-latest"

New-Item -Path ".\ARM-TTK" -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $ARMTTK_DownloadLocation -OutFile ".\ARM-TTK\ARM-TTK.zip"
Expand-Archive -Path ".\ARM-TTK\ARM-TTK.zip" -DestinationPath ".\ARM-TTK" -Force

Import-Module ".\ARM-TTK\arm-ttk\arm-ttk.psd1" -Force
Import-Module -Name Pester -MaximumVersion 4.10.1

Get-ChildItem -Path .\ARM\* -Include arm-ttk-tests.ps1 -Recurse -File | ForEach-Object {
  Write-Host "Running ARM-TTK on Directory - " $_.Directory.Name
  Invoke-Pester -Script $_ -OutputFile (Join-Path -Path $outputPath -ChildPath ($_.Directory.Name + ".nunit")) -OutputFormat NUnitXml
}

Remove-Item ".\ARM-TTK" -Recurse -Force

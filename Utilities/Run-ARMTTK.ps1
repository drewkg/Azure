Invoke-WebRequest -Uri "https://aka.ms/arm-ttk-latest" -OutFile ".\ARM-TTK.zip"
Expand-Archive -Path ".\ARM-TTK.zip" -DestinationPath ".\ARM-TTK" -Force
Import-Module ".\ARM-TTK\arm-ttk\arm-ttk.psd1"
Import-Module -Name Pester -MaximumVersion 4.10.1
Set-Location "."
Get-ChildItem -Name arm-ttk-tests.ps1 -recurse -Path . | ForEach {
  Invoke-Pester -Script (".\" + $_) -OutputFile (".\" + $_.Split('\')[$_.Split('\').Count - 2]  + ".nunit") -OutputFormat NUnitXml
}
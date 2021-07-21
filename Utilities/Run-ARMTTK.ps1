New-Item -Path ".\ARM-TTK" -ItemType Directory -Force
Invoke-WebRequest -Uri "https://aka.ms/arm-ttk-latest" -OutFile ".\ARM-TTK\ARM-TTK.zip"
Expand-Archive -Path ".\ARM-TTK\ARM-TTK.zip" -DestinationPath ".\ARM-TTK" -Force

Import-Module ".\ARM-TTK\arm-ttk\arm-ttk.psd1"
Import-Module -Name Pester -MaximumVersion 4.10.1
Set-Location "."
Get-ChildItem -Name arm-ttk-tests.ps1 -recurse -Path . | ForEach {
  Invoke-Pester -Script (".\" + $_) -OutputFile (".\ARM-TTK\" + $_.Split('\')[$_.Split('\').Count - 2]  + ".nunit") -OutputFormat NUnitXml
}
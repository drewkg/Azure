<#
 Get things ready before deploying components onto the agent
#>

function Disable-InternetExplorerESC {
  $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
  Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
  Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
  Stop-Process -Name Explorer -Force -ErrorAction Continue
  Write-Host "IE Enhanced Security Configuration (ESC) has been disabled."
}

function Disable-InternetExplorerWelcomeScreen {
  $AdminKey = "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main"
  New-Item -Path $AdminKey -Value 1 -Force
  Set-ItemProperty -Path $AdminKey -Name "DisableFirstRunCustomize" -Value 1 -Force
  Write-Host "Disabled IE Welcome screen"
}

function Disable-UserAccessControl {
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force
  Write-Host "User Access Control (UAC) has been disabled."
}

# get helper module files ready for import
Copy-Item -Path 'C:\buildartifacts\Powershell\ImageHelpers' `
          -Destination 'C:\Program Files\WindowsPowerShell\Modules\' `
          -Recurse `
          -Force

Write-Output "Importing ImageHelpers"
Import-Module -Name ImageHelpers -Force

Write-Host "Setup Nuget as package provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Write-Host "Setup PowerShellGet"
Install-Module -Name PowerShellGet -Force
Write-Host "Set PSGallery as trusted"
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery

# Install .NET Framework 3.5 (required by Chocolatey)
Write-Host "Installs dotNET 3.5"
# Install-WindowsFeature -Name NET-Framework-Features -IncludeAllSubFeature
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All

# Explicitly install all 4.7 sub features to include ASP.Net.
# As of  1/16/2019, WinServer 19 lists .Net 4.7 as NET-Framework-45-Features
Write-Host "Installs dotNET 4.7"
# Install-WindowsFeature -Name NET-Framework-45-Features -IncludeAllSubFeature
Dism /online /Enable-Feature /FeatureName:NetFx4 /All

Write-Host "Disable IE Welcome Screen"
Disable-InternetExplorerWelcomeScreen

Write-Host "Disable IE ESC"
Disable-InternetExplorerESC

Write-Host "Setting local execution policy"
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine  -ErrorAction Continue | Out-Null
Get-ExecutionPolicy -List

Write-Host "Enable long path behavior"
# See https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file#maximum-path-length-limitation
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

Write-Host "Install chocolatey"
$chocoExePath = 'C:\ProgramData\Chocolatey\bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower())) {
  Write-Host "Chocolatey found in PATH, skipping install..."
  Exit
}

# Add to system PATH
$systemPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
$systemPath += ';' + $chocoExePath
[Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

# Update local process' path
$userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($userPath) {
  $env:Path = $systemPath + ";" + $userPath
}
else {
  $env:Path = $systemPath
}

# Run the installer
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor "Tls12"
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Turn off confirmation
choco feature enable -n allowGlobalConfirmation

################################################################################
##  File:  Install-AzureModules.ps1
##  Desc:  Install Azure PowerShell modules
################################################################################

Set-PSRepository -InstallationPolicy Trusted -Name PSGallery

#### NOW The correct Modules need to be saved in C:\Modules
$installPSModulePath = 'C:\Modules'
if(-not (Test-Path -LiteralPath $installPSModulePath))
{
    Write-Host "Creating '$installPSModulePath' folder to store PowerShell Azure modules"
    $null = New-Item -Path $installPSModulePath -ItemType Directory
}

# Powershell Azure modules to install
$psAzureModulesToInstall = @{

    "az" = @(
        "1.0.0"
        "1.6.0"
        "2.3.2"
        "2.6.0"
        "3.1.0"
        "3.5.0"
    )

    "az.blueprint" = @(
        "0.2.10"
    )

    "az.managedserviceidentity" = @(
        "0.7.3"
    )
}

Install-Module -Name Az -RequiredVersion 3.5.0 -AllowClobber -Force
Install-Module -Name Az.Blueprint -RequiredVersion 0.2.10 -AllowClobber -Force
Install-Module -Name Az.Security -RequiredVersion 0.7.6 -AllowClobber -Force
Install-Module -Name Az.ManagedServiceIdentity -RequiredVersion 0.7.3 -AllowClobber -Force

# Download Azure PowerShell modules
#foreach($psmoduleName in $psAzureModulesToInstall.Keys)
#{
#    Write-Host "Installing '$psmoduleName' to the '$installPSModulePath' path:"
#    $psmoduleVersions = $psAzureModulesToInstall[$psmoduleName]
#    foreach($psmoduleVersion in $psmoduleVersions)
#    {
#        $psmodulePath = Join-Path $installPSModulePath "${psmoduleName}_${psmoduleVersion}"
#        Write-Host " - $psmoduleVersion [$psmodulePath]"
#        try
#        {
#            Save-Module -Path $psmodulePath -Name $psmoduleName -RequiredVersion $psmoduleVersion -Force -ErrorAction Stop
#        }
#        catch
#        {
#            Write-Host "Error: $_"
#            exit 1
#        }
#    }
#}

#Try {
  # Add AzureRM and Azure modules to the PSModulePath
  #$finalModulePath = '{0};{1};{2};{3}' -f "${installPSModulePath}\azurerm_2.1.0", "${installPSModulePath}\azure_2.1.0", $installPSModulePath, $env:PSModulePath
  #[Environment]::SetEnvironmentVariable("PSModulePath", $finalModulePath, "Machine")

  # TODO - register the highest installed version of the powershell scripts so that we can check the requirements in AzDo

  ##Install-Module -Name Az -RequiredVersion 3.5.0 -AllowClobber -Force
  ##Install-Module -Name Az.Blueprint -RequiredVersion 0.2.10 -AllowClobber -Force
  ##Install-Module -Name Az.ManagedIdentityService -RequiredVersion 0.7.3 -AllowClobber -Force
#}
#Catch {
#  exit 1
#}

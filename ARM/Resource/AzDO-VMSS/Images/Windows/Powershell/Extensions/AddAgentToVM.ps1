[CmdletBinding()]
Param(
    [string]$VSTSToken = "__vststoken__",
    [string]$DevOpsTenant = "newsigcode",
    [string]$VSTSUrl="https://dev.azure.com/$($DevOpsTenant)",
    [string]$AgentVersionNumber = '2.165.0',
    [string]$windowsLogonAccount = "__windowslogonaccount__",
    [string]$windowsLogonPassword = "__windowslogonpassword__",
    [string]$poolName = "default"
)

$ErrorActionPreference="Stop";

If(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
     throw "Run command in Administrator PowerShell Prompt"
};

if(-NOT (Test-Path $env:SystemDrive\'a'))
{
    mkdir $env:SystemDrive\'a'
};

Set-Location $env:SystemDrive\'a';

# ensure folder exists - retry if required
for($i=1; $i -lt 100; $i++)
{
    $destFolder="A"+$i.ToString();
    if(-NOT (Test-Path ($destFolder)))
    {
        mkdir $destFolder;
        Set-Location $destFolder;
        break;
    }
};

$agentZip="$PWD\agent.zip";

$DefaultProxy=[System.Net.WebRequest]::DefaultWebProxy;
$WebClient=New-Object Net.WebClient;

$Uri="https://vstsagentpackage.azureedge.net/agent/$($AgentVersionNumber)/vsts-agent-win-x64-$($AgentVersionNumber).zip";
if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($Uri)))
{
    $WebClient.Proxy = New-Object Net.WebProxy($DefaultProxy.GetProxy($Uri).OriginalString, $True);
};

$WebClient.DownloadFile($Uri, $agentZip);
Add-Type -AssemblyName System.IO.Compression.FileSystem;[System.IO.Compression.ZipFile]::ExtractToDirectory($agentZip, "$PWD");

.\config.cmd --unattended `
             --url $VSTSUrl `
             --auth PAT `
             --token $VSTSToken `
             --pool $poolName `
             --agent $env:COMPUTERNAME `
             --replace `
             --runasservice `
             --work '_work' `
             --windowsLogonAccount $windowsLogonAccount `
             --windowsLogonPassword $windowsLogonPassword

Remove-Item $agentZip;

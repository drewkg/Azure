<#
  Copyright (c) Microsoft Corporation. All rights reserved.
  Licensed under the MIT License.
#>

<#
  .SYNOPSIS
  Update Azure PowerShell modules in an Azure Automation account.

  .DESCRIPTION
  This Azure Automation runbook updates Azure PowerShell modules imported into an
  Azure Automation account with the module versions published to the PowerShell Gallery.

  Prerequisite: an Azure Automation account with an Azure Run As account credential.

  .PARAMETER ResourceGroupName
  The Azure resource group name.

  .PARAMETER AutomationAccountName
  The Azure Automation account name.

  .PARAMETER AzureEnvironment
  (Optional) Azure environment name.

  .PARAMETER Login
  (Optional) If $false, do not login to Azure.
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param(
  [Parameter(Mandatory = $true)]
  [string] $ResourceGroupName,

  [Parameter(Mandatory = $true)]
  [string] $AutomationAccountName,

  [string] $AzureEnvironment = 'AzureCloud',

  [bool] $Login = $true
)

$ErrorActionPreference = "Continue"

@description('URI to artifacts location')
param artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param artifactsLocationSasToken string = ''

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'demo'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('Base time for all calcuations, default is Now() in UTC')
param baseTime string = utcNow('u')

var environment_var = environment
var automationAccountName_var = 'webhook-${environment_var}-${location}-aa'
var runbookName_var = 'webhook-${environment_var}-${location}-runbook'
var webhookName_var = 'webhook-${environment_var}-${location}-wh'
var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: automationAccountName_var
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource runbook_resource 'runbooks@2018-06-30' = {
    name: runbookName_var
    location: location
    properties: {
      runbookType: 'PowerShell'
      logProgress: false
      logVerbose: false
      description: 'Sample Runbook'
      publishContentLink: {
        uri: '${artifactsLocation}/Script/HelloWorld.ps1${artifactsLocationSasToken}'
        version: '1.0.0.0'
      }
    }
  }

  resource automationAccountName_webhookName 'webhooks@2015-10-31' = {
    name: webhookName_var
    properties: {
      isEnabled: true
      expiryTime: add3Years
      runbook: {
        name: runbookName_var
      }
    }
    dependsOn: [
      runbook_resource
    ]
  }
}

output webhookUri string = reference(webhookName_var).uri

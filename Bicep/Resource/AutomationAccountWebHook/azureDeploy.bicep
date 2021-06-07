@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param Location string = resourceGroup().location

@description('Automation account name')
param automationAccountName string = 'Webhook-aa'

@description('Webhook Name')
param webhookName string = 'Sample-wh'

@description('Runbook Name for which webhook will be created')
param runbookName string = 'SampleRunbook'

@description('Webhook Expiry time')
param WebhookExpiryTime string = dateTimeAdd(utcNow('u'), 'P3Y')

@description('URI to artifacts location')
param artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param artifactsLocationSasToken string = ''

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: automationAccountName
  location: Location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

resource automationAccountName_runbookName 'Microsoft.Automation/automationAccounts/runbooks@2018-06-30' = {
  name: '${automationAccountName_resource.name}/${runbookName}'
  location: Location
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

resource automationAccountName_webhookName 'Microsoft.Automation/automationAccounts/webhooks@2018-06-30' = {
  name: '${automationAccountName_resource.name}/${webhookName}'
  properties: {
    isEnabled: true
    expiryTime: WebhookExpiryTime
    runbook: {
      name: runbookName
    }
  }
  dependsOn: [
    automationAccountName_runbookName
  ]
}

output webhookUri string = reference(webhookName).uri

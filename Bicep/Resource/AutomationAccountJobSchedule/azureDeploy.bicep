@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param Location string = resourceGroup().location

@description('URI to artifacts location')
param artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param artifactsLocationSasToken string = ''

@description('Automation account name')
param automationAccountName string = 'Webhook-aa'

@description('Runbook Name for which webhook will be created')
param runbookName string = 'SampleRunbook'

@description('Base time for all calcuations, default is Noe() in UTC')
param baseTime string = utcNow('u')

var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2021-04-01' = {
  name: automationAccountName
  location: Location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource automationAccountName_runbookName 'runbooks@2020-01-13-preview' = {
    name: runbookName
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

  resource runbookSchedule 'schedules@2021-04-01' = {
    name: 'RunbookSchedule'
    location: Location
    properties: {
      description: 'Basic Schedule'
      expiryTime: add3Years
      frequency: 'Day'
      interval: 1
      timeZone: 'UTC'
    }
  }

  resource jobSchedules 'jobSchedules@2021-04-01' = {
    name: guid('HelloWorldJobSchedule')
    properties: {
      runbook: {
        name: runbookName
      }
      schedule: {
        name: runbookSchedule
      }
    }
  }
}

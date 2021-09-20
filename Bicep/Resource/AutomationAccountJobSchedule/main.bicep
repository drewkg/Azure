@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param Location string = resourceGroup().location

@description('URI to artifacts location')
param _artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param artifactsLocationSasToken string = ''

@description('Automation account name')
param automationAccountName string = 'JobSchedule-aa'

@description('Base time for all calcuations, default is Now() in UTC')
param baseTime string = utcNow('u')

var add10Minutes = dateTimeAdd(baseTime, 'P10M')
var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2019-06-01' = {
  name: automationAccountName
  location: Location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource runbookName_resource 'runbooks@2019-06-01' = {
    name: 'HelloWorldRunbook'
    location: Location
    properties: {
      runbookType: 'PowerShell'
      logProgress: false
      logVerbose: false
      description: 'Sample Runbook'
      publishContentLink: {
        uri: '${_artifactsLocation}/Script/HelloWorld.ps1${artifactsLocationSasToken}'
        version: '1.0.0.0'
      }
    }
  }

  resource runbookSchedule_resource 'schedules@2019-06-01' = {
    name: 'RunbookSchedule'
    properties: {
      description: 'Basic Schedule'
      startTime: add10Minutes
      expiryTime: add3Years
      frequency: 'Day'
      interval: 1
      timeZone: 'UTC'
    }
  }

  resource jobSchedules 'jobSchedules@2019-06-01' = {
    name: guid('HelloWorldJobSchedule')
    properties: {
      runbook: {
        name: runbookName_resource.name
      }
      schedule: {
        name: runbookSchedule_resource.name
      }
    }
  }
}

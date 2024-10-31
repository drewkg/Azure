@description('URI to artifacts location')
param _artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param _artifactsLocationSasToken string = ''

@description('Base time for all calculations, default is Now() in UTC')
param baseTime string = utcNow('u')

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'ObjInt'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

var automationAccountName = 'demo-${environment}-${location}-aa'
var add10Minutes = dateTimeAdd(baseTime, 'P10M')
var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource runbookName 'runbooks' = {
    name: 'HelloWorldRunbook'
    location: location
    properties: {
      runbookType: 'PowerShell'
      logProgress: false
      logVerbose: false
      description: 'Sample Runbook'
      publishContentLink: {
        uri: '${_artifactsLocation}/Script/HelloWorld.ps1${_artifactsLocationSasToken}'
        version: '1.0.0.0'
      }
    }
  }

  resource runbookSchedule 'schedules' = {
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

  resource jobSchedules 'jobSchedules' = {
    name: guid('HelloWorldJobSchedule')
    properties: {
      runbook: {
        name: runbookName.name
      }
      schedule: {
        name: runbookSchedule.name
      }
    }
  }
}

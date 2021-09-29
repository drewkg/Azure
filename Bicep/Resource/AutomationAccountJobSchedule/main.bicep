@description('URI to artifacts location')
param _artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param _artifactsLocationSasToken string = ''

@description('Base time for all calcuations, default is Now() in UTC')
param baseTime string = utcNow('u')

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'ObjInt'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

var environment_var = environment
var applicationInsightsName_var = 'demo-${environment_var}-${location}-aa'
var add10Minutes = dateTimeAdd(baseTime, 'P10M')
var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2019-06-01' = {
  name: applicationInsightsName_var
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource runbookName_resource 'runbooks@2019-06-01' = {
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

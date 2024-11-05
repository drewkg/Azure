@description('URI to artifacts location')
param _artifactsLocation string = deployment().properties.templateLink.uri

@secure()
@description('SAS Token as a Query String')
param _artifactsLocationSasToken string = ''

@description('Base time for all calculations, default is Now() in UTC')
param baseTime string = utcNow('u')

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'ObjInt'

var automationAccountName = '${application}-${environment}-${location}-aa'
var add10Minutes = dateTimeAdd(baseTime, 'P10M')
var add3Years = dateTimeAdd(baseTime, 'P3Y')

resource AutomationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }

  resource runbook 'runbooks' = {
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

  resource Schedule 'schedules' = {
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

  // This has to be a guid, and globally unique. Additionally you cannot reuse a guid if the jobSchedule is deleted.
  resource jobSchedules 'jobSchedules' = {
    name: guid('${AutomationAccount.id}-${Schedule.id}')
    properties: {
      runbook: {
        name: runbook.name
      }
      schedule: {
        name: Schedule.name
      }
    }
  }
}

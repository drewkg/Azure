@description('URI to artifacts location')
param _artifactsLocation string = substring(deployment().properties.templateLink.uri, 0, lastIndexOf(deployment().properties.templateLink.uri, '/'))

@secure()
param _artifactsLocationSasToken string = ''

@description('The location of the resources created, this is limited to only the locations that support linked Log Analytics and Automation Account.')
@allowed([
  'eastus'
  'westus2'
  'canadacentral'
  'australiasoutheast'
  'southeastasia'
  'centralindia'
  'japaneast'
  'uksouth'
  'westeurope'
  'usgovvirginia'
])
param location string = 'uksouth'

param environment string = 'test'

@description('Allows the override of the default naming convention. If specified there are 3 tags that can be utilized, {0} - the environment type, {1} - the location code and {2} - the resource moniker')
param namingConvention string = 'platform-{0}-{1}-{2}'

param locationShortCodeOverride object = {
  eastus: 'eus'
  westus2: 'wus'
  canadacentral: 'cc'
  australiasoutheast: 'ase'
  southeastasia: 'sea'
  centralindia: 'ci'
  japaneast: 'je'
  uksouth: 'uks'
  westeurope: 'weu'
  usgovvirginia: 'usgv'
}

@description('Object to allow the overriding of the default naming convention, by specifying the name of each individual resources. If used then all resources need to be defined.')
param resourceNameOverride object = {
  logAnalyticsWorkspaceName: format(namingConvention, environment, locationShortCodeOverride[location], 'log')
  automationAccountName: format(namingConvention, environment, locationShortCodeOverride[location], 'aa')
}

@description('Date for Automation Accounts schedules to start on, defaults to the next days, this should be ALWAYS left as the default.')
param baseTime string = utcNow('u')

var logAnalyticsWorkspaceName = resourceNameOverride['logAnalyticsWorkspaceName']
var automationAccountName = resourceNameOverride['automationAccountName']
var scheduleStartDate = dateTimeAdd(baseTime, 'P1D', 'yyyy-MM-dd')

output Subscription string = subscription().subscriptionId
output ResourceGroup string = resourceGroup().name
output LogAnalyticsWorkspaceName string = logAnalyticsWorkspaceName
output AutomationAccountName string = automationAccountName

resource logAnalyticsWorkspace_resource 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
  resource linkedService_resource 'linkedServices@2020-08-01' = {
    name: 'Automation'
    properties: {
      resourceId: automationAccount_resource.id
    }
  }
}

resource solution_AzureActivity_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('AzureActivity({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('AzureActivity({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'AzureActivity')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace_resource.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('AzureActivity({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource solution_AzureAutomation_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('AzureAutomation({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('AzureAutomation({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'AzureAutomation')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace_resource.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('AzureAutomation({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource solution_KeyVault_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'KeyVaultAnalytics')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace_resource.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource solution_SecurityCenterFree_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('SecurityCenterFree({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('SecurityCenterFree({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'SecurityCenterFree')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace_resource.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('SecurityCenterFree({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource diagnosticSettings_LogAnalyticsWorkspace_resource 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnosticSettings'
  scope: logAnalyticsWorkspace_resource
  properties: {
    workspaceId: logAnalyticsWorkspace_resource.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]
    logs: [
      {
        category: 'Audit'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]
  }
}

resource automationAccount_resource 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Basic'
    }
  }

  resource UpdateAutomationAzureModulesForAccount 'runbooks@2019-06-01' = {
    name: 'Update-AutomationAzureModulesForAccount'
    properties: {
      runbookType: 'PowerShell'
      logProgress: false
      logVerbose: false
      description: 'Update Azure PowerShell modules in an Azure Automation account.'
      publishContentLink: {
        uri: uri(_artifactsLocation, 'Runbook/Powershell/Update-AutomationAzureModulesForAccount.ps1${_artifactsLocationSasToken}')
        version: '1.0.0.0'
      }
    }
  }

  resource UpdateAzurePolicyComplianceState 'runbooks@2019-06-01' = {
    name: 'Update-AzurePolicyComplianceState'
    properties: {
      runbookType: 'PowerShell'
      logProgress: false
      logVerbose: false
      description: 'Update Azure PowerShell modules in an Azure Automation account.'
      publishContentLink: {
        uri: uri(_artifactsLocation, 'Runbook/Powershell/Update-AzurePolicyComplianceState.ps1${_artifactsLocationSasToken}')
        version: '1.0.0.0'
      }
    }
  }

  resource UpdateAutomationAzureModulesForAccountSchedule 'schedules@2019-06-01' = {
    name: 'Update-AutomationAzureModulesForAccountSchedule'
    properties: {
      description: 'Update-AutomationAzureModulesForAccount Monthly Schedule'
      startTime: format('{0}T02:00:00Z', scheduleStartDate)
      advancedSchedule: {
        monthlyOccurrences: [
          {
            day: 'Sunday'
            occurrence: 1
          }
        ]
      }
      frequency: 'Month'
      timeZone: 'Europe/London'
    }
  }

  resource UpdateAzurePolicyComplianceStateSchedule 'schedules@2019-06-01' = {
    name: 'Update-AzurePolicyComplianceStateSchedule'
    properties: {
      description: 'Update-AzurePolicyComplianceStateSchedule Daily Schedule'
      startTime: format('{0}T01:00:00Z', scheduleStartDate)
      advancedSchedule: {
        weekDays: [
          'monday'
          'tuesday'
          'wednesday'
          'thursday'
          'friday'
          'saturday'
          'sunday'
        ]
      }
      frequency: 'Day'
      timeZone: 'Europe/London'
    }
  }

  /*resource UpdateAutomationAzureModulesForAccountJobSchedule 'jobSchedules@2021-04-01' = {
    name: guid('${resourceGroup().id}/UpdateAutomationAzureModulesForAccountJobSchedule')
    properties: {
      parameters: {
        ResourceGroupName: resourceGroup().name
        AutomationAccountName: automationAccount_resource.name
      }
      runbook: {
        name: UpdateAutomationAzureModulesForAccount.name
      }
      schedule: {
        name: UpdateAutomationAzureModulesForAccountSchedule.name
      }
    }
  }*/
}

resource diagnosticSettings_automationAccount_resource 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnosticSettings'
  scope: automationAccount_resource
  properties: {
    workspaceId: logAnalyticsWorkspace_resource.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    logs: [
      {
        category: 'JobLogs'
        enabled: true
      }
      {
        category: 'JobStreams'
        enabled: true
      }
      {
        category: 'DscNodeStatus'
        enabled: true
      }
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
  }
}

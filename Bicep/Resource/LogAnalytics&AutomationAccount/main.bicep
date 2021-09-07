@description('The location of the resources created, excluding \'Global\', defaults to UKSouth.')
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

@description('Object to allow the overriding of the default naming convention, by specifying the naming individual resources. If used then all resources need to be defined.')
param resourceNameOverride object = {
  logAnalyticsWorkspaceName: format(namingConvention, locationShortCodeOverride[location], environment, 'log')
  automationAccountName: format(namingConvention, locationShortCodeOverride[location], environment, 'aa')
}

var logAnalyticsWorkspaceName = resourceNameOverride['logAnalyticsWorkspaceName']
var automationAccountName = resourceNameOverride['automationAccountName']

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
  }
}

resource diagnosticSettings_LogAnalyticsWorkspace_resource 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
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
      }
    ]
  }
}

resource automationAccount_resource 'Microsoft.Automation/automationAccounts@2021-04-01' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource diagnosticSettings_automationAccount_resource 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
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
    ]
  }
}

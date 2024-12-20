@description('URI to artifacts location')
param _artifactsLocation string = substring(deployment().properties.templateLink.uri, 0, lastIndexOf(deployment().properties.templateLink.uri, '/'))

@secure()
param _artifactsLocationSasToken string = ''

@description('The location of the resources created, this is limited to only the locations that support linked Log Analytics and Automation Account.')
@allowed([
  'EastUS'
  'EastUS2'
  'WestUS'
  'WestUS2'
  'NorthCentralUS'
  'CentralUS'
  'SouthCentralUS'
  'WestCentralUS'
  'BrazilSouth'
  'CanadaCentral'
  'EastAsia'
  'SouthEastAsia'
  'CentralIndia'
  'JapanEast'
  'AustraliaEast'
  'AustraliaSouthEast'
  'KoreaCentral'
  'NorwayEast'
  'NorthEurope'
  'WestEurope'
  'FranceCentral'
  'UKSouth'
  'SwitzerlandNorth'
  'UAENorth'
])
param location string = 'UKSouth'

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

@description('Date for Automation Accounts schedules to start on, defaults to the next day, this should be ALWAYS left as the default.')
param baseTime string = utcNow('u')

var automationAccountName = '${application}-${environment}-${automationAccountLocation}-aa'
var automationAccountLocation = (location == 'EastUS') ? 'EastUS2' : (location == 'EastUS2') ? 'EastUS' : location
var logAnalyticsWorkspaceName = '${application}-${environment}-${location}-log'
var scheduleStartDate = dateTimeAdd(baseTime, 'P1D', 'yyyy-MM-dd')

output Subscription string = subscription().subscriptionId
output ResourceGroup string = resourceGroup().name
output LogAnalyticsWorkspaceName string = logAnalyticsWorkspaceName
output AutomationAccountName string = automationAccountName

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }

  resource automationLinkedService 'linkedServices@2020-08-01' = {
    name: 'Automation'
    properties: {
      resourceId: AutomationAccount.id
    }
  }
}

resource AzureActivitySolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('AzureActivity({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('AzureActivity({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'AzureActivity')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: LogAnalyticsWorkspace.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('AzureActivity({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource AzureAutomationSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('AzureAutomation({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('AzureAutomation({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'AzureAutomation')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: LogAnalyticsWorkspace.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('AzureAutomation({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource KeyVaultSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'KeyVaultAnalytics')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: LogAnalyticsWorkspace.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('KeyVaultAnalytics({0})', logAnalyticsWorkspaceName))
    ]
  }
}

resource SecurityCenterFreeSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('SecurityCenterFree({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('SecurityCenterFree({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', 'SecurityCenterFree')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: LogAnalyticsWorkspace.id
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('SecurityCenterFree({0})', logAnalyticsWorkspaceName))
    ]
  }
}

#disable-next-line use-recent-api-versions
resource logAnalyticsDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnosticSettings'
  scope: LogAnalyticsWorkspace
  properties: {
    workspaceId: LogAnalyticsWorkspace.id
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

resource AutomationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: automationAccountLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Basic'
    }
  }

  resource UpdateAutomationAzureModulesForAccount 'runbooks' = {
    name: 'Update-AutomationAzureModulesForAccount'
    location: location
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

  resource UpdateAzurePolicyComplianceState 'runbooks' = {
    name: 'Update-AzurePolicyComplianceState'
    location: location
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

  resource UpdateAutomationAzureModulesForAccountSchedule 'schedules' = {
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
      interval: any(1)
    }
  }

  resource UpdateAzurePolicyComplianceStateSchedule 'schedules' = {
    name: 'Update-AzurePolicyComplianceStateSchedule'
    properties: {
      description: 'Update-AzurePolicyComplianceStateSchedule Daily Schedule'
      startTime: format('{0}T01:00:00Z', scheduleStartDate)
      frequency: 'Day'
      timeZone: 'Europe/London'
      interval: any(1)
    }
  }

  resource UpdateAutomationAzureModulesForAccountJobSchedule 'jobSchedules' = {
    name: guid('${UpdateAutomationAzureModulesForAccount.id}-${UpdateAutomationAzureModulesForAccountSchedule.id}')
    properties: {
      parameters: {
        ResourceGroupName: resourceGroup().name
        AutomationAccountName: AutomationAccount.name
      }
      runbook: {
        name: UpdateAutomationAzureModulesForAccount.name
      }
      schedule: {
        name: UpdateAutomationAzureModulesForAccountSchedule.name
      }
    }
  }
}

resource AutomationContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(format('{0}{1}', resourceGroup().id, 'AAMSIAutomationContributorAssignment'))
  scope: AutomationAccount
  properties: {
    description: 'MSI granted Automation Contributor on Automation Account, to manage modules.'
    principalId: AutomationAccount.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f353d9bd-d4a6-484e-a77a-8050b599b867')
  }
}

resource LogAnalyticsContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(format('{0}{1}', resourceGroup().id, 'AAMSILogAnalyticsContributorAssignment'))
  scope: LogAnalyticsWorkspace
  properties: {
    description: 'MSI granted Log Analytics Contributor on Log Analytics Workspace, to query shared access keys.'
    principalId: AutomationAccount.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  }
}

#disable-next-line use-recent-api-versions
resource AutomationDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnosticSettings'
  scope: AutomationAccount
  properties: {
    workspaceId: LogAnalyticsWorkspace.id
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

param location string
param resourceName string

param AutomationAccountId string = ''

param DiagnosticSettings bool = true

param OMSSolutions array = [
  'AzureActivity'
  'AzureAutomation'
  'AzureDiagnostics'
  'KeyVaultAnalytics'
  'SecurityCenterFree'
]

output LogAnalyticsWorksapceId string = resourceId('Microsoft.OperationalInsights/workspaces', resourceName)

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: resourceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }

  resource automationLinkedService 'linkedServices' = if (AutomationAccountId != '') {
    name: 'Automation'
    properties: {
      resourceId: AutomationAccountId
    }
  }
}

module solutions 'WorkspaceSolution.bicep' = [for solution in OMSSolutions: {
  name: '${solution}Deployment'
  params: {
    SolutionName: solution
    location: location
    logAnalyticsWorkspaceName: resourceName
    LogAnalyticsWorkspaceId: LogAnalyticsWorkspace.id
  }
}]

#disable-next-line use-recent-api-versions
resource logAnalyticsDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (DiagnosticSettings) {
  name: 'diagnosticSettings'
  scope: LogAnalyticsWorkspace
  properties: {
    workspaceId: LogAnalyticsWorkspace.id
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
  }
}

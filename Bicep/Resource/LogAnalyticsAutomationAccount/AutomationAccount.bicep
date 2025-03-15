@description('URI to artifacts location')
param _artifactsLocation string = substring(deployment().properties.templateLink.uri, 0, lastIndexOf(deployment().properties.templateLink.uri, '/'))

@secure()
param _artifactsLocationSasToken string = ''

param location string
param automationAccountResourceName string
param logAnalyticsWorkspaceResourceName string

@description('Date for Automation Accounts schedules to start on, defaults to the next day, this should be ALWAYS left as the default.')
param scheduleStartDate string = dateTimeAdd(utcNow('u'), 'P1D', 'yyyy-MM-dd')

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceResourceName

  resource automationLinkedService 'linkedServices' = {
    name: 'Automation'
    properties: {
      resourceId: AutomationAccount.id
    }
  }
}


resource AutomationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountResourceName
  location: location
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
  }
}

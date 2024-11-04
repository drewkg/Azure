targetScope = 'managementGroup'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = deployment().location
param logAnalyticsSubscription string = ''
param logAnalyticsResourceGroup string = ''
param logAnalyticsWorkspace string = ''

resource ContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  scope: tenant()
}

resource DiagnosticInitiative 'Microsoft.Authorization/policySetDefinitions@2024-05-01' existing = {
  name: 'diagnostics-loganalytics-deploy-initiative'
  scope: managementGroup()
}

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspace
  scope: resourceGroup(logAnalyticsSubscription, logAnalyticsResourceGroup)
}

resource diagnosticsAssignmentName 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: substring(replace(guid('Diagnostics & Metrics (MG ${managementGroup().name})'), '-', ''), 0, 24)
  location: location
  scope: managementGroup()
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Diagnostics & Metrics (MG ${managementGroup().name})'
    description: 'Apply diagnostic & metric settings for Azure Resources to stream data to a Log Analytics workspace when any Azure Resource which is missing this diagnostic settings is created or updated.'
    policyDefinitionId: DiagnosticInitiative.id
    parameters: {
      logAnalytics: {
        value: LogAnalyticsWorkspace.id
      }
    }
  }
}

resource diagnosticsContributorRBACName 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('Diagnostics & Metrics (MG ${managementGroup().id}) Contributor Assignment')
  scope: managementGroup()
  properties: {
    roleDefinitionId: ContributorRole.id
    principalId: diagnosticsAssignmentName.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

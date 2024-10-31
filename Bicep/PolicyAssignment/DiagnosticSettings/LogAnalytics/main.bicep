targetScope = 'managementGroup'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = deployment().location
param logAnalyticsSubscription string = ''
param logAnalyticsResourceGroup string = ''
param logAnalyticsWorkspace string = ''

resource diagnosticsAssignmentName 'Microsoft.Authorization/policyAssignments@2024-05-01' = {
  name: substring(replace(guid(format('Diagnostics & Metrics (MG {0})', managementGroup().name)), '-', ''), 0, 24)
  location: location
  scope: managementGroup()
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: format('Diagnostics & Metrics (MG {0})', managementGroup().name)
    description: 'Apply diagnostic & metric settings for Azure Resources to stream data to a Log Analytics workspace when any Azure Resource which is missing this diagnostic settings is created or updated.'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'diagnostics-loganalytics-deploy-initiative')
    parameters: {
      logAnalytics: {
        value: format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}', logAnalyticsSubscription, logAnalyticsResourceGroup, logAnalyticsWorkspace)
      }
    }
  }
}

resource diagnosticsContributorRBACName 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(format('Diagnostics & Metrics (MG {0}) Contributor Assignment', managementGroup().id))
  scope: managementGroup()
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: diagnosticsAssignmentName.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

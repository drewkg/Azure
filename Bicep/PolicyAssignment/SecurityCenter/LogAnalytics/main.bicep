targetScope = 'managementGroup'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = deployment().location

@allowed([
  'On'
  'Off'
])
param autoProvisioningSetting string = 'Off'

param logAnalyticsSubscription string = ''
param logAnalyticsResourceGroup string = ''
param logAnalyticsWorkspace string = ''

resource SecurityCenterAssignmentName 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: substring(replace(guid(format('Security Center (MG {0})', managementGroup().name)), '-', ''), 0, 24)
  location: location
  scope: managementGroup()
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: format('Security Center (MG {0})', managementGroup().name)
    description: 'Applies Security Center Settings to an Azure Subscription.'
    policyDefinitionId: extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroup().name), 'Microsoft.Authorization/policySetDefinitions', 'securitycenter-deploy-initiative')
    parameters: {
      autoProvisioningSetting: {
        value: autoProvisioningSetting
      }
      logAnalytics: {
        value: format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}', logAnalyticsSubscription, logAnalyticsResourceGroup, logAnalyticsWorkspace)
      }
    }
  }
}

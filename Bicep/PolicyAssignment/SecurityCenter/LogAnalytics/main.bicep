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
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'securitycenter-deploy-initiative')
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

resource SecurityCenterContributorRBACName 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(format('Security Center (MG {0}) Contributor Assignment', managementGroup().id))
  scope: managementGroup()
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: reference(resourceId('Microsoft.Authorization/policyAssignments', SecurityCenterAssignmentName.name), '2021-06-01', 'Full').identity.principalId
  }
}

resource SecurityCenterSecurityAdminRBACName 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(format('Security Center (MG {0}) Security Admin Assignment', managementGroup().id))
  scope: managementGroup()
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
    principalId: reference(resourceId('Microsoft.Authorization/policyAssignments', SecurityCenterAssignmentName.name), '2021-06-01', 'Full').identity.principalId
  }
}

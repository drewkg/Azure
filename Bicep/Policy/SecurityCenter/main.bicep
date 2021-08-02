targetScope = 'managementGroup'

module getManagementGroupNameDeploy './Modules/empty.bicep' = {
  // temporary fix
  // this is a no-op to get the name of the managementGroup for the policyDefintion, i.e. the name of the mg for this deployment'
  name: 'getManagementGroupName'
  scope: managementGroup()
}

module AzureDefenderSubDeployPolicy './Modules/azureDefender-sub-deploy-policy.bicep' = {
  name: 'azureDefender-sub-deploy-policy'
}

module AutoProvisioningSubDeployPolicy './Modules/autoprovisioning-sub-deploy-policy.bicep' = {
  name: 'autoprovisioning-sub-deploy-policy'
}

module DiagnosticsLogAnalyticsPolicySet './Modules/securitycenter-deploy-initiative.bicep' = {
  name: 'diagnostics-loganalytics-deploy'
  params: {
    policyDefinitionId: [
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', AzureDefenderSubDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', AutoProvisioningSubDeployPolicy.outputs.name)
    ]
  }
}

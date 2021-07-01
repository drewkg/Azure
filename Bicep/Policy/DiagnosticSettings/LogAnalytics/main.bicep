
targetScope = 'managementGroup'

module getManagementGroupNameDeploy 'empty.bicep' = {
  // temporary fix
  // this is a no-op to get the name of the managementGroup for the policyDefintion, i.e. the name of the mg for this deployment'
  name: 'getManagementGroupName'
  scope: managementGroup()
}

module DiagnosticsAADeployPolicy './diagnostics-aa-deploy-policy.bicep' = {
  name: 'diagnostics-aa-deploy-policy'
}

module DiagnosticsADFDeployPolicy './diagnostics-adf-deploy-policy.bicep' = {
  name: 'diagnostics-adf-deploy-policy'
}

module DiagnosticsAGWDeployPolicy './diagnostics-agw-deploy-policy.bicep' = {
  name: 'diagnostics-agw-deploy-policy'
}

module DiagnosticsLogAnalyticsPolicySet './policySetDef.bicep' = {
  name: 'diagnostics-loganalytics-deploy'
  params: {
    policyDefinitionId: [
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('Microsoft.Resources/deployments/getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAADeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('Microsoft.Resources/deployments/getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsADFDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('Microsoft.Resources/deployments/getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAGWDeployPolicy.outputs.name)
    ]
  }
}

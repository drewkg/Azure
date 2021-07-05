
targetScope = 'managementGroup'

module getManagementGroupNameDeploy './Modules/empty.bicep' = {
  // temporary fix
  // this is a no-op to get the name of the managementGroup for the policyDefintion, i.e. the name of the mg for this deployment'
  name: 'getManagementGroupName'
  scope: managementGroup()
}

module DiagnosticsAADeployPolicy './Modules/diagnostics-aa-deploy-policy.bicep' = {
  name: 'diagnostics-aa-deploy-policy'
}

module DiagnosticsADFDeployPolicy './Modules/diagnostics-adf-deploy-policy.bicep' = {
  name: 'diagnostics-adf-deploy-policy'
}

module DiagnosticsAGWDeployPolicy './Modules/diagnostics-agw-deploy-policy.bicep' = {
  name: 'diagnostics-agw-deploy-policy'
}

module DiagnosticsAKSDeployPolicy './Modules/diagnostics-agw-deploy-policy.bicep' = {
  name: 'diagnostics-aks-deploy-policy'
}

module DiagnosticsAPIMDeployPolicy './Modules/diagnostics-apim-deploy-policy.bicep' = {
  name: 'diagnostics-apim-deploy-policy'
}

module DiagnosticsAPPDeployPolicy './Modules/diagnostics-app-deploy-policy.bicep' = {
  name: 'diagnostics-app-deploy-policy'
}

module DiagnosticsASDeployPolicy './Modules/diagnostics-as-deploy-policy.bicep' = {
  name: 'diagnostics-as-deploy-policy'
}

module DiagnosticsASADeployPolicy './Modules/diagnostics-asa-deploy-policy.bicep' = {
  name: 'diagnostics-asa-deploy-policy'
}

module DiagnosticsLogAnalyticsPolicySet './Modules/diagnostics-loganalytics-deploy-initiative.bicep' = {
  name: 'diagnostics-loganalytics-deploy'
  params: {
    policyDefinitionId: [
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAADeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsADFDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAGWDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAKSDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAPIMDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsAPPDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsASDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsASADeployPolicy.outputs.name)
    ]
  }
}

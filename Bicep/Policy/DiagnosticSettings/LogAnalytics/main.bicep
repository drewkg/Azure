
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

module DiagnosticsBATCHDeployPolicy './Modules/diagnostics-batch-deploy-policy.bicep' = {
  name: 'diagnostics-batch-deploy-policy'
}

module DiagnosticsCDNEDeployPolicy './Modules/diagnostics-cdne-deploy-policy.bicep' = {
  name: 'diagnostics-cdne-deploy-policy'
}

module DiagnosticsCIDeployPolicy './Modules/diagnostics-ci-deploy-policy.bicep' = {
  name: 'diagnostics-ci-deploy-policy'
}

module DiagnosticsCOGDeployPolicy './Modules/diagnostics-cog-deploy-policy.bicep' = {
  name: 'diagnostics-cog-deploy-policy'
}

module DiagnosticsCOSMOSDeployPolicy './Modules/diagnostics-cosmos-deploy-policy.bicep' = {
  name: 'diagnostics-cosmos-deploy-policy'
}

module DiagnosticsCRDeployPolicy './Modules/diagnostics-cr-deploy-policy.bicep' = {
  name: 'diagnostics-cr-deploy-policy'
}

module DiagnosticsDLADeployPolicy './Modules/diagnostics-dla-deploy-policy.bicep' = {
  name: 'diagnostics-dla-deploy-policy'
}

module DiagnosticsDLSDeployPolicy './Modules/diagnostics-dls-deploy-policy.bicep' = {
  name: 'diagnostics-dls-deploy-policy'
}

module DiagnosticsERCDeployPolicy './Modules/diagnostics-erc-deploy-policy.bicep' = {
  name: 'diagnostics-erc-deploy-policy'
}

module DiagnosticsESUBDeployPolicy './Modules/diagnostics-esub-deploy-policy.bicep' = {
  name: 'diagnostics-esub-deploy-policy'
}

module DiagnosticsEVGTDeployPolicy './Modules/diagnostics-evgt-deploy-policy.bicep' = {
  name: 'diagnostics-evgt-deploy-policy'
}

module DiagnosticsEVHNSDeployPolicy './Modules/diagnostics-evhns-deploy-policy.bicep' = {
  name: 'diagnostics-evhns-deploy-policy'
}

module DiagnosticsFDDeployPolicy './Modules/diagnostics-fd-deploy-policy.bicep' = {
  name: 'diagnostics-fd-deploy-policy'
}

module DiagnosticsFUNCDeployPolicy './Modules/diagnostics-func-deploy-policy.bicep' = {
  name: 'diagnostics-func-deploy-policy'
}

module DiagnosticsFWDeployPolicy './Modules/diagnostics-fw-deploy-policy.bicep' = {
  name: 'diagnostics-fw-deploy-policy'
}

module DiagnosticsHDINSIGHTDeployPolicy './Modules/diagnostics-hdinsight-deploy-policy.bicep' = {
  name: 'diagnostics-hdinsight-deploy-policy'
}

module DiagnosticsIADeployPolicy './Modules/diagnostics-ia-deploy-policy.bicep' = {
  name: 'diagnostics-ia-deploy-policy'
}

module DiagnosticsIOTDeployPolicy './Modules/diagnostics-iot-deploy-policy.bicep' = {
  name: 'diagnostics-iot-deploy-policy'
}

module DiagnosticsKVDeployPolicy './Modules/diagnostics-kv-deploy-policy.bicep' = {
  name: 'diagnostics-kv-deploy-policy'
}

module DiagnosticsLBDeployPolicy './Modules/diagnostics-lb-deploy-policy.bicep' = {
  name: 'diagnostics-lb-deploy-policy'
}

module DiagnosticsLOGDeployPolicy './Modules/diagnostics-log-deploy-policy.bicep' = {
  name: 'diagnostics-log-deploy-policy'
}

module DiagnosticsLOGICDeployPolicy './Modules/diagnostics-logic-deploy-policy.bicep' = {
  name: 'diagnostics-logic-deploy-policy'
}

module DiagnosticsMYSQLDeployPolicy './Modules/diagnostics-mysql-deploy-policy.bicep' = {
  name: 'diagnostics-mysql-deploy-policy'
}

module DiagnosticsNETDeployPolicy './Modules/diagnostics-net-deploy-policy.bicep' = {
  name: 'diagnostics-net-deploy-policy'
}

module DiagnosticsNICDeployPolicy './Modules/diagnostics-nic-deploy-policy.bicep' = {
  name: 'diagnostics-nic-deploy-policy'
}

module DiagnosticsNSGDeployPolicy './Modules/diagnostics-nsg-deploy-policy.bicep' = {
  name: 'diagnostics-nsg-deploy-policy'
}

module DiagnosticsPBIDeployPolicy './Modules/diagnostics-pbi-deploy-policy.bicep' = {
  name: 'diagnostics-pbi-deploy-policy'
}

module DiagnosticsPIPDeployPolicy './Modules/diagnostics-pip-deploy-policy.bicep' = {
  name: 'diagnostics-pip-deploy-policy'
}

module DiagnosticsPLANDeployPolicy './Modules/diagnostics-plan-deploy-policy.bicep' = {
  name: 'diagnostics-plan-deploy-policy'
}

module DiagnosticsPSQLDeployPolicy './Modules/diagnostics-psql-deploy-policy.bicep' = {
  name: 'diagnostics-psql-deploy-policy'
}

module DiagnosticsREDISDeployPolicy './Modules/diagnostics-redis-deploy-policy.bicep' = {
  name: 'diagnostics-redis-deploy-policy'
}

module DiagnosticsRELAYDeployPolicy './Modules/diagnostics-relay-deploy-policy.bicep' = {
  name: 'diagnostics-relay-deploy-policy'
}

module DiagnosticsRSVDeployPolicy './Modules/diagnostics-rsv-deploy-policy.bicep' = {
  name: 'diagnostics-rsv-deploy-policy'
}

module DiagnosticsSBDeployPolicy './Modules/diagnostics-sb-deploy-policy.bicep' = {
  name: 'diagnostics-sb-deploy-policy'
}

module DiagnosticsSIGRDeployPolicy './Modules/diagnostics-sigr-deploy-policy.bicep' = {
  name: 'diagnostics-sigr-deploy-policy'
}

module DiagnosticsSQLDBDeployPolicy './Modules/diagnostics-sqldb-deploy-policy.bicep' = {
  name: 'diagnostics-sqldb-deploy-policy'
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
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsBATCHDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsCDNEDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsCIDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsCOGDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsCOSMOSDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsCRDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsDLADeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsDLSDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsERCDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsESUBDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsEVGTDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsEVHNSDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsFDDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsFUNCDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsFWDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsHDINSIGHTDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsIADeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsIOTDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsKVDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsLBDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsLOGDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsLOGICDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsMYSQLDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsNETDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsNICDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsNSGDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsPBIDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsPIPDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsPLANDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsPSQLDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsREDISDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsRELAYDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsRSVDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsSBDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsSIGRDeployPolicy.outputs.name)
      extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', DiagnosticsSQLDBDeployPolicy.outputs.name)
    ]
  }
}

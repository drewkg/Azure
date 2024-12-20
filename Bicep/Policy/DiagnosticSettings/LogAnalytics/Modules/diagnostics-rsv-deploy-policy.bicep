targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2024-05-01' = {
  name: 'diagnostics-rsv-deploy-policy'
  properties: {
    displayName: 'Deploy Diagnostics & Metrics for Recovery Services Vault to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for Recovery Services Vault to stream data to a Log Analytics workspace when any Recovery Services Vault which is missing this diagnostic settings is created or updated.'
    metadata: {
      category: 'Monitoring'
      version: '1.0.0.0'
    }
    mode: 'All'
    parameters: {
      profileName: {
        type: 'String'
        metadata: {
          displayName: 'Profile name'
          description: 'The diagnostic settings profile name'
        }
        defaultValue: 'setbypolicy_logAnalytics'
      }
      logAnalytics: {
        type: 'String'
        metadata: {
          displayName: 'Log Analytics workspace'
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant \'Log Analytics Contributor\' permissions (or similar) to the policy assignment\'s principal ID.'
          strongType: 'omsWorkspace'
          assignPermissions: true
        }
      }
    }
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.RecoveryServices/vaults'
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          type: 'Microsoft.Insights/diagnosticSettings'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                equals: 'True'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/metrics.enabled'
                equals: 'True'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/workspaceId'
                matchInsensitively: '[parameters(\'logAnalytics\')]'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  profileName: {
                    type: 'string'
                  }
                  logAnalytics: {
                    type: 'string'
                  }
                  resourceName: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    name: '[parameters(\'profileName\')]'
                    type: 'Microsoft.Insights/diagnosticSettings'
                    apiVersion: '2021-05-01-preview'
                    scope: '[resourceId(\'Microsoft.RecoveryServices/vaults\', parameters(\'resourceName\'))]'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      logs: [
                        {
                          category: 'AzureBackupReport'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryJobs'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryEvents'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryReplicatedItems'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryReplicationStats'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryRecoveryPoints'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryReplicationDataUploadRate'
                          enabled: true
                        }
                        {
                          category: 'AzureSiteRecoveryProtectedDiskDataChurn'
                          enabled: true
                        }
                        {
                          category: 'CoreAzureBackup'
                          enabled: true
                        }
                        {
                          category: 'AddonAzureBackupJobs'
                          enabled: true
                        }
                        {
                          category: 'AddonAzureBackupAlerts'
                          enabled: true
                        }
                        {
                          category: 'AddonAzureBackupPolicy'
                          enabled: true
                        }
                        {
                          category: 'AddonAzureBackupStorage'
                          enabled: true
                        }
                        {
                          category: 'AddonAzureBackupProtectedInstance'
                          enabled: true
                        }

                      ]
                    }
                  }
                ]
              }
              parameters: {
                profileName: {
                  value: '[parameters(\'profileName\')]'
                }
                logAnalytics: {
                  value: '[parameters(\'logAnalytics\')]'
                }
                resourceName: {
                  value: '[field(\'name\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}

targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'diagnostics-wvdhostpool-deploy-policy'
  properties: {
    displayName: 'Deploy Diagnostics & Metrics for Virtual Desktop Host Pools to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for Virtual Desktop Host Pools to stream data to a Log Analytics workspace when any Virtual Desktop Host Pools which is missing this diagnostic settings is created or updated.'
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
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.DesktopVirtualization/hostPools'
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
                    scope: '[resourceId(\'Microsoft.DesktopVirtualization/hostPools\', parameters(\'resourceName\'))]'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      logs: [
                        {
                          category: 'Checkpoint'
                          enabled: true
                        }
                        {
                          category: 'Error'
                          enabled: true
                        }
                        {
                          category: 'Management'
                          enabled: true
                        }
                        {
                          category: 'Connection'
                          enabled: true
                        }
                        {
                          category: 'HostRegistration'
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

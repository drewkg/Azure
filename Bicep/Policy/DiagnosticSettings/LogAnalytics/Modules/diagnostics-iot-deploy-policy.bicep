targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2024-05-01' = {
  name: 'diagnostics-iot-deploy-policy'
  properties: {
    displayName: 'Deploy Diagnostics & Metrics for IoT Hubs  to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for IoT Hubs  to stream data to a Log Analytics workspace when any IoT Hubs  which is missing this diagnostic settings is created or updated.'
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
        equals: 'Microsoft.Devices/IotHubs'
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
                    scope: '[resourceId(\'Microsoft.Devices/IotHubs\', parameters(\'resourceName\'))]'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'AllMetrics'
                          enabled: true
                          retentionPolicy: {
                            days: 0
                            enabled: false
                          }
                          timeGrain: null
                        }
                      ]
                      logs: [
                        {
                          category: 'Connections'
                          enabled: true
                        }
                        {
                          category: 'DeviceTelemetry'
                          enabled: true
                        }
                        {
                          category: 'C2DCommands'
                          enabled: true
                        }
                        {
                          category: 'DeviceIdentityOperations'
                          enabled: true
                        }
                        {
                          category: 'FileUploadOperations'
                          enabled: true
                        }
                        {
                          category: 'Routes'
                          enabled: true
                        }
                        {
                          category: 'D2CTwinOperations'
                          enabled: true
                        }
                        {
                          category: 'C2DTwinOperations'
                          enabled: true
                        }
                        {
                          category: 'TwinQueries'
                          enabled: true
                        }
                        {
                          category: 'JobsOperations'
                          enabled: true
                        }
                        {
                          category: 'DirectMethods'
                          enabled: true
                        }
                        {
                          category: 'E2EDiagnostics'
                          enabled: true
                        }
                        {
                          category: 'Configurations'
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

targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'diagnostics-plan-deploy-policy'
  properties:  {
    displayName: 'Deploy Diagnostics & Metrics for App Service Plan to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for App Service Plan to stream data to a Log Analytics workspace when any App Service Plan which is missing this diagnostic settings is created or updated.'
    metadata:  {
      category: 'Monitoring'
      version: '1.0.0.0'
    }
    mode: 'All'
    parameters:  {
      profileName:  {
        type: 'String'
        metadata:  {
          displayName: 'Profile name'
          description: 'The diagnostic settings profile name'
        }
        defaultValue: 'setbypolicy_logAnalytics'
      }
      logAnalytics:  {
        type: 'String'
        metadata:  {
          displayName: 'Log Analytics workspace'
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant \'Log Analytics Contributor\' permissions (or similar) to the policy assignment\'s principal ID.'
          strongType: 'omsWorkspace'
          assignPermissions:  true
        }
      }
    }
    policyType: 'Custom'
    policyRule:  {
      if:  {
        field: 'type'
        equals: 'Microsoft.Web/serverfarms'
      }
      then:  {
        effect: 'deployIfNotExists'
        details:  {
          type: 'Microsoft.Insights/diagnosticSettings'
          roleDefinitionIds:  [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          existenceCondition:  {
            allOf:  [
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
          deployment:  {
            properties:  {
              mode: 'incremental'
              template:  {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters:  {
                  profileName:  {
                    type: 'string'
                  }
                  logAnalytics:  {
                    type: 'string'
                  }
                  resourceName:  {
                    type: 'string'
                  }
                }
                resources:  [
                  {
                    name: '[parameters(\'profileName\')]'
                    type: 'Microsoft.Insights/diagnosticSettings'
                    apiVersion: '2021-05-01-preview'
                    scope: '[resourceId(\'Microsoft.Web/serverfarms\', parameters(\'resourceName\'))]'
                    properties:  {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics:  [
                        {
                          category: 'AllMetrics'
                          enabled:  true
                          retentionPolicy:  {
                            days:  0
                            enabled:  false
                          }
                          timeGrain:  null
                        }
                      ]
                    }
                  }
                ]
              }
              parameters:  {
                profileName:  {
                  value: '[parameters(\'profileName\')]'
                }
                logAnalytics:  {
                  value: '[parameters(\'logAnalytics\')]'
                }
                resourceName:  {
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

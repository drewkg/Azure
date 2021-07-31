targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'diagnostics-sub-deploy-policy'
  properties: {
    displayName: 'Deploy Diagnostics & Metrics for Subscription to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for Subscription to stream data to a Log Analytics workspace when any Subscription which is missing this diagnostic settings is created or updated.'
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
        equals: 'Microsoft.Resources/subscriptions'
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          type: 'microsoft.insights/diagnosticSettings'
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                equals: 'True'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/workspaceId'
                equals: '[parameters(\'logAnalytics\')]'
              }
            ]
          }
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          deploymentScope: 'subscription'
          deployment: {
            location: 'eastus'
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  profileName: {
                    type: 'string'
                  }
                  logAnalytics: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    type: 'microsoft.insights/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[parameters(\'profileName\')]'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      logs: [
                        {
                          category: 'Administrative'
                          enabled: true
                        }
                        {
                          category: 'Security'
                          enabled: true
                        }
                        {
                          category: 'ServiceHealth'
                          enabled: true
                        }
                        {
                          category: 'Alert'
                          enabled: true
                        }
                        {
                          category: 'Recommendation'
                          enabled: true
                        }
                        {
                          category: 'Policy'
                          enabled: true
                        }
                        {
                          category: 'Autoscale'
                          enabled: true
                        }
                        {
                          category: 'ResourceHealth'
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
              }
            }
          }
        }
      }
    }
  }
}

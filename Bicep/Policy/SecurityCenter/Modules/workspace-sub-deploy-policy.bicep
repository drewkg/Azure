targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2024-05-01' = {
  name: 'workspace-sub-deploy-policy'
  properties: {
    displayName: 'Configure Security Center Workspace'
    description: 'Configures Security Center Auto Provisioning Workspace'
    metadata: {
      category: 'Security Center'
      version: '1.0.0.0'
    }
    mode: 'All'
    parameters: {
      logAnalytics: {
        type: 'String'
        metadata: {
          displayName: 'Log Analytics workspace'
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant \'Log Analytics Contributor\' permissions (or similar) to the policy assignment\'s principal ID.'
        }
        defaultValue: ''
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
          type: 'Microsoft.Security/workspaceSettings'
          existenceScope: 'subscription'
          existenceCondition: {
            allof: [
              {
                field: 'Microsoft.Security/workspaceSettings/workspaceId'
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
                  logAnalytics: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    type: 'Microsoft.Security/workspaceSettings'
                    apiVersion: '2019-01-01'
                    name: 'default'
                    properties: {
                      autoProvision: '[parameters(\'logAnalytics\')]'
                    }
                  }
                ]
              }
              parameters: {
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

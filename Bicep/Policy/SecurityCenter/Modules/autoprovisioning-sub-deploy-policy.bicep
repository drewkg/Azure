targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'autoprovisioning-sub-deploy-policy'
  properties: {
    displayName: 'Configure Security Center Auto Provisioning'
    description: 'Configures Security Center Auto Provisioning'
    metadata: {
      category: 'Security Center'
      version: '1.0.0.0'
    }
    mode: 'All'
    parameters: {
      autoProvisioningSetting: {
        type: 'String'
        metadata: {
          displayName: 'Auto Provisioning Setting'
          description: 'Specify whether you want to enable auto provisioning of VM\'s to a log analytics workspace.'
        }
        defaultValue: 'Off'
        allowedValues: [
          'Off'
          'On'
        ]
      }
      logAnalytics: {
        type: 'String'
        metadata: {
          displayName: 'Log Analytics workspace'
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant \'Log Analytics Contributor\' permissions (or similar) to the policy assignment\'s principal ID.'
          strongType: 'omsWorkspace'
          assignPermissions: true
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
          type: 'Microsoft.Security/autoProvisioningSettings'
          existenceScope: 'subscription'
          existenceCondition: {
            allof: [
              {
                field: 'Microsoft.Security/autoProvisioningSettings/autoProvision'
                equals: '[parameters(\'autoProvisioningSetting\')]'
              }
              {
                field: 'Microsoft.Security/workspaceSettings/workspaceId'
                equals: '[parameters(\'logAnalytics\')]'
              }
            ]
          }
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
            '/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd'
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
                  autoProvisioningSetting: {
                    type: 'string'
                  }
                  logAnalytics: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    type: 'Microsoft.Security/autoProvisioningSettings'
                    apiVersion: '2019-01-01'
                    name: 'default'
                    properties: {
                      autoProvision: '[parameters(\'autoProvisioningSetting\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/workspaceSettings'
                    apiVersion: '2019-01-01'
                    name: 'default'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      scope: '[subscription().id]'
                    }
                  }
                ]
              }
              parameters: {
                autoProvisioningSetting: {
                  value: '[parameters(\'autoProvisioningSetting\')]'
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

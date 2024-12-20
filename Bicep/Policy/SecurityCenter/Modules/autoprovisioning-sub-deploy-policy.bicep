targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2024-05-01' = {
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
                  autoProvisioningSetting: {
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
                ]
              }
              parameters: {
                autoProvisioningSetting: {
                  value: '[parameters(\'autoProvisioningSetting\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}

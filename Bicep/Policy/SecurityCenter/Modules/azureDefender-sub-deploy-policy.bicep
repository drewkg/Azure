targetScope = 'managementGroup'

output name string = policy.name

resource policy 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'azuredefender-sub-deploy-policy'
  properties: {
    displayName: 'Configure Azure Defender Plans'
    description: 'Configures Azure Defender Plans to an Azure Subscription.'
    metadata: {
      category: 'Security Center'
      version: '1.0.0.0'
    }
    mode: 'All'
    parameters: {
      appServiceTier: {
        type: 'String'
        metadata: {
          displayName: 'App Service Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for App Services resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      armServiceTier: {
        type: 'String'
        metadata: {
          displayName: 'ARM Pricing Tier'
          description: 'Specify whether you want to enable standard tier for ARM operations.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      containerRegistryTier: {
        type: 'String'
        metadata: {
          displayName: 'App Service Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Container Registry resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      dnsTier: {
        type: 'String'
        metadata: {
          displayName: 'DNS Pricing Tier'
          description: 'Specify whether you want to enable standard tier for DNS resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      keyVaultTier: {
        type: 'String'
        metadata: {
          displayName: 'Key Vault Pricing Tier'
          description: 'Specify whether you want to enable standard tier for Key Vault resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      kubernetesServiceTier: {
        type: 'String'
        metadata: {
          displayName: 'App Service Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Kubernetes resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      openSourceRelationalDatabasesServiceTier: {
        type: 'String'
        metadata: {
          displayName: 'Open Source Relational Databases Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Open Source Relational Databases resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      sqlServerTier: {
        type: 'String'
        metadata: {
          displayName: 'Sql Server Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Sql Server resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      sqlServerVirtualMachineTier: {
        type: 'String'
        metadata: {
          displayName: 'Sql Server Virtual Machine Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Sql Server Virtual Machines resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      storageAccountTier: {
        type: 'String'
        metadata: {
          displayName: 'Storage Account Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Storage Account resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
        ]
      }
      virtualMachineTier: {
        type: 'String'
        metadata: {
          displayName: 'Virtual Service Pricing Tier'
          description: 'Specify whether you want to enable Standard tier for Virtual Machine resource type.'
        }
        defaultValue: 'Free'
        allowedValues: [
          'Free'
          'Standard'
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
          type: 'Microsoft.Security/pricings'
          existenceScope: 'subscription'
          existenceCondition: {
            anyof: [
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'AppServices'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'appServiceTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'Arm'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'armServiceTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'Dns'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'appServiceTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'ContainerRegistry'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'containerRegistryTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'KeyVaults'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'keyVaultTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'KubernetesService'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'kubernetesServiceTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'OpenSourceRelationalDatabases'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'openSourceRelationalDatabasesServiceTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'SqlServers'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'sqlServerTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'SqlServerVirtualMachines'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'sqlServerVirtualMachineTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'StorageAccounts'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'storageAccountTier\')]'
                  }
                ]
              }
              {
                allof: [
                  {
                    field: 'name'
                    equals: 'VirtualMachines'
                  }
                  {
                    field: 'microsoft.security/pricings/pricingTier'
                    equals: '[[parameters(\'virtualMachineTier\')]'
                  }
                ]
              }
            ]
          }
          roleDefinitionIds: [
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
                  appServiceTier: {
                    type: 'string'
                  }
                  armServiceTier: {
                    type: 'string'
                  }
                  containerRegistryTier: {
                    type: 'string'
                  }
                  dnsTier: {
                    type: 'string'
                  }
                  keyVaultTier: {
                    type: 'string'
                  }
                  kubernetesServiceTier: {
                    type: 'string'
                  }
                  openSourceRelationalDatabasesServiceTier: {
                    type: 'string'
                  }
                  sqlServerTier: {
                    type: 'string'
                  }
                  sqlServerVMTier: {
                    type: 'string'
                  }
                  storageAccountTier: {
                    type: 'string'
                  }
                  virtualMachineTier: {
                    type: 'string'
                  }
                }
                resources: [
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'AppServices'
                    properties: {
                      pricingTier: '[[parameters(\'appServiceTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'Arm'
                    properties: {
                      pricingTier: '[[parameters(\'appServiceTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'ContainerRegistry'
                    properties: {
                      pricingTier: '[[parameters(\'containerRegistryTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'Dns'
                    properties: {
                      pricingTier: '[[parameters(\'keyVaultTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'KeyVaults'
                    properties: {
                      pricingTier: '[[parameters(\'keyVaultTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'KubernetesService'
                    properties: {
                      pricingTier: '[[parameters(\'kubernetesServiceTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'OpenSourceRelationalDatabases'
                    properties: {
                      pricingTier: '[[parameters(\'openSourceRelationalDatabasesServiceTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'SqlServers'
                    properties: {
                      pricingTier: '[[parameters(\'sqlServerTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'SqlServerVirtualMachines'
                    properties: {
                      pricingTier: '[[parameters(\'sqlServerVMTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'StorageAccounts'
                    properties: {
                      pricingTier: '[[parameters(\'storageAccountTier\')]'
                    }
                  }
                  {
                    type: 'Microsoft.Security/pricings'
                    apiVersion: '2018-06-01'
                    name: 'VirtualMachines'
                    properties: {
                      pricingTier: '[[parameters(\'virtualMachineTier\')]'
                    }
                  }
                ]
              }
              parameters: {
                appServiceTier: {
                  value: '[[parameters(\'appServiceTier\')]'
                }
                armServiceTier: {
                  value: '[[parameters(\'armServiceTier\')]'
                }
                containerRegistryTier: {
                  value: '[[parameters(\'containerRegistryTier\')]'
                }
                dnsTier: {
                  value: '[[parameters(\'dnsTier\')]'
                }
                keyVaultTier: {
                  value: '[[parameters(\'keyVaultTier\')]'
                }
                kubernetesServiceTier: {
                  value: '[[parameters(\'kubernetesServiceTier\')]'
                }
                openSourceRelationalDatabasesServiceTier: {
                  value: '[[parameters(\'openSourceRelationalDatabasesServiceTier\')]'
                }
                sqlServerTier: {
                  value: '[[parameters(\'sqlServerTier\')]'
                }
                sqlServerVMTier: {
                  value: '[[parameters(\'sqlServerVirtualMachineTier\')]'
                }
                storageAccountTier: {
                  value: '[[parameters(\'storageAccountTier\')]'
                }
                virtualMachineTier: {
                  value: '[[parameters(\'virtualMachineTier\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}

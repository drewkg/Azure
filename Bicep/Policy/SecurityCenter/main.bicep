targetScope = 'managementGroup'

module getManagementGroupNameDeploy './Modules/empty.bicep' = {
  // temporary fix
  // this is a no-op to get the name of the managementGroup for the policyDefintion, i.e. the name of the mg for this deployment'
  name: 'getManagementGroupName'
  scope: managementGroup()
}

module AzureDefenderSubDeployPolicy './Modules/azureDefender-sub-deploy-policy.bicep' = {
  name: 'azureDefender-sub-deploy-policy'
}

module AutoProvisioningSubDeployPolicy './Modules/autoprovisioning-sub-deploy-policy.bicep' = {
  name: 'autoprovisioning-sub-deploy-policy'
}

resource PolicyDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'diagnostics-loganalytics-deploy-initiative'
  properties: {
    displayName: 'Deploy Configurations for Azure Security Center to a Subscription'
    description: 'Apply configurations of Azure Security Center to a Subscription when the settings are missing or incorrect.'
    policyType: 'Custom'
    metadata: {
      category: 'Security Center'
      verion: '1.0.0'
    }
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
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant Log Analytics Contributor permissions (or similar) to the policy assignments principal ID.'
          strongType: 'omsWorkspace'
          assignPermissions: true
        }
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', AzureDefenderSubDeployPolicy.outputs.name)
        parameters: {
          appServiceTier: {
            value: '[parameters(\'appServiceTier\')]'
          }
          armServiceTier: {
            value: '[parameters(\'armServiceTier\')]'
          }
          containerRegistryTier: {
            value: '[parameters(\'containerRegistryTier\')]'
          }
          dnsTier: {
            value: '[parameters(\'dnsTier\')]'
          }
          keyVaultTier: {
            value: '[parameters(\'keyVaultTier\')]'
          }
          kubernetesServiceTier: {
            value: '[parameters(\'kubernetesServiceTier\')]'
          }
          openSourceRelationalDatabasesServiceTier: {
            value: '[parameters(\'openSourceRelationalDatabasesServiceTier\')]'
          }
          sqlServerTier: {
            value: '[parameters(\'sqlServerTier\')]'
          }
          sqlServerVirtualMachineTier: {
            value: '[parameters(\'sqlServerVirtualMachineTier\')]'
          }
          storageAccountTier: {
            value: '[parameters(\'storageAccountTier\')]'
          }
          virtualMachineTier: {
            value: '[parameters(\'virtualMachineTier\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', split(reference('getManagementGroupName', '2020-10-01', 'Full').scope, '/')[2]), 'Microsoft.Authorization/policyDefinitions', AutoProvisioningSubDeployPolicy.outputs.name)
        parameters: {
          autoProvisioningSetting: {
            value: '[parameters(\'autoProvisioningSetting\')]'
          }
        }
      }
    ]
  }
}

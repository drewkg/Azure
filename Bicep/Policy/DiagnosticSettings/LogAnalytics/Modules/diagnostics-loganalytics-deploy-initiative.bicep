targetScope = 'managementGroup'

param policyDefinitionId array

resource PolicyDefinition 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'diagnostics-loganalytics-deploy-initiative'
  properties: {
    displayName: 'Deploy Diagnostics & Metrics for Azure Resource to a Log Analytics workspace'
    description: 'Apply diagnostic & metric settings for Azure Resources to stream data to a Log Analytics workspace when any Azure Resource which is missing this diagnostic settings is created or updated.'
    policyType: 'Custom'
    metadata: {
      category: 'Monitoring'
      verion: '1.0.0'
    }
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
          description: 'Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant Log Analytics Contributor permissions (or similar) to the policy assignments principal ID.'
          strongType: 'omsWorkspace'
          assignPermissions: true
        }
      }
    }
    policyDefinitions: [for policydef in policyDefinitionId: {
      policyDefinitionId: policydef
      parameters: {
        profileName: {
          value: '[[parameters(\'profileName\')]'
        }
        logAnalytics: {
          value: '[[parameters(\'logAnalytics\')]'
        }
      }
    }]
  }
}

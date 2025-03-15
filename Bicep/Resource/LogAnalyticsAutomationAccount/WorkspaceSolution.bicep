param SolutionName string
param location string
param logAnalyticsWorkspaceName string
param LogAnalyticsWorkspaceId string

resource AzureActivitySolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: format('${SolutionName}({0})', logAnalyticsWorkspaceName)
  location: location
  plan: {
    name: format('${SolutionName}({0})', logAnalyticsWorkspaceName)
    publisher: 'Microsoft'
    product: format('OMSGallery/{0}', '${SolutionName}')
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: LogAnalyticsWorkspaceId
    containedResources: [
      resourceId('Microsoft.OperationalInsights/workspaces/views/', logAnalyticsWorkspaceName, format('${SolutionName}({0})', logAnalyticsWorkspaceName))
    ]
  }
}

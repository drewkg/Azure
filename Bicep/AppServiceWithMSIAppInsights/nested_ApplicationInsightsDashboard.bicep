@description('The resource name for the Application Insights dashboard.')
param applicationInsightsDashboardName string

@description('The resource name for the Application Insights instance.')
param applicationInsightsName string

@description('The location of the resources created, excluding \'Global\'.')
param resourceLocation string

resource applicationInsightsDashboardName_resource 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: applicationInsightsDashboardName
  location: resourceLocation
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: resourceId('Microsoft.Insights/components', applicationInsightsName)
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
              asset: {
                idInputName: 'id'
                type: 'ApplicationInsights'
              }
              defaultMenuItemId: 'overview'
            }
          }
        ]
      }
    ]
  }
  tags: {
    'hidden-title': '${applicationInsightsName} Dashboard'
  }
}
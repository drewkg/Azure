@description('The resource name for the Application Insights dashboard.')
param applicationInsightsDashboardName string

@description('The resource name for the Application Insights instance.')
param applicationInsightsName string

@description('The visible title for the Application Insights dashboard.')
param applicationInsightsDashboardTitle string

@description('The location of the resources created excluding \'Global\'.')
param resourceLocation string

resource ApplicationInsightsDashboard 'Microsoft.Portal/dashboards@2022-12-01-preview' = {
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
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'id'
                type: 'ApplicationInsights'
              }
#disable-next-line BCP037
              defaultMenuItemId: 'overview'
            }
          }
          {
            position: {
              x: 2
              y: 0
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/ProactiveDetectionAsyncPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
#disable-next-line BCP037
              defaultMenuItemId: 'ProactiveDetection'
            }
          }
          {
            position: {
              x: 3
              y: 0
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'ResourceId'
                  value: resourceId('Microsoft.Insights/components', applicationInsightsName)
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/QuickPulseButtonSmallPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          {
            position: {
              x: 4
              y: 0
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'TimeContext'
                  value: {
                    durationMs: 86400000
                    isInitialTime: true
                    grain: 1
                    useDashboardTimeRange: false
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/AvailabilityNavButtonPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          {
            position: {
              x: 5
              y: 0
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'TimeContext'
                  value: {
                    durationMs: 86400000
                    isInitialTime: true
                    grain: 1
                    useDashboardTimeRange: false
                  }
                }
                {
                  name: 'ConfigurationId'
                  value: '78ce933e-e864-4b05-a27b-71fd55a6afad'
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/AppMapButtonPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          {
            position: {
              x: 0
              y: 1
              rowSpan: 1
              colSpan: 3
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '# Usage'
                    title: ''
                    subtitle: ''
                  }
                }
              }
            }
          }
          {
            position: {
              x: 3
              y: 1
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'TimeContext'
                  value: {
                    durationMs: 86400000
                    isInitialTime: true
                    grain: 1
                    useDashboardTimeRange: false
                  }
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/UsageUsersOverviewPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          {
            position: {
              x: 4
              y: 1
              rowSpan: 1
              colSpan: 3
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '# Reliability'
                    title: ''
                    subtitle: ''
                  }
                }
              }
            }
          }
          {
            position: {
              x: 7
              y: 1
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ResourceId'
                  value: resourceId('Microsoft.Insights/components', applicationInsightsName)
                }
                {
                  name: 'DataModel'
                  value: {
                    version: '1.0.0'
                    timeContext: {
                      durationMs: 86400000
                      isInitialTime: false
                      grain: 1
                      useDashboardTimeRange: false
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '8a02f7bf-ac0f-40e1-afe9-f0e72cfee77f'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/CuratedBladeFailuresPinnedPart'
#disable-next-line BCP037
              isAdapter: true
#disable-next-line BCP037
              asset: {
                idInputName: 'ResourceId'
                type: 'ApplicationInsights'
              }
#disable-next-line BCP037
              defaultMenuItemId: 'failures'
            }
          }
          {
            position: {
              x: 8
              y: 1
              rowSpan: 1
              colSpan: 3
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '# Responsiveness\r\n'
                    title: ''
                    subtitle: ''
                  }
                }
              }
            }
          }
          {
            position: {
              x: 11
              y: 1
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ResourceId'
                  value: resourceId('Microsoft.Insights/components', applicationInsightsName)
                }
                {
                  name: 'DataModel'
                  value: {
                    version: '1.0.0'
                    timeContext: {
                      durationMs: 86400000
                      isInitialTime: false
                      grain: 1
                      useDashboardTimeRange: false
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'ConfigurationId'
                  value: '2a8ede4f-2bee-4b9c-aed9-2db0e8a01865'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/CuratedBladePerformancePinnedPart'
#disable-next-line BCP037
              isAdapter: true
#disable-next-line BCP037
              asset: {
                idInputName: 'ResourceId'
                type: 'ApplicationInsights'
              }
#disable-next-line BCP037
              defaultMenuItemId: 'performance'
            }
          }
          {
            position: {
              x: 12
              y: 1
              rowSpan: 1
              colSpan: 3
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '# Browser'
                    title: ''
                    subtitle: ''
                  }
                }
              }
            }
          }
          {
            position: {
              x: 15
              y: 1
              rowSpan: 1
              colSpan: 1
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'MetricsExplorerJsonDefinitionId'
                  value: 'BrowserPerformanceTimelineMetrics'
                }
                {
                  name: 'TimeContext'
                  value: {
                    durationMs: 86400000
                    isInitialTime: false
                    grain: 1
                    useDashboardTimeRange: false
                  }
                }
                {
                  name: 'CurrentFilter'
                  value: {
                    eventTypes: [
                      4
                      1
                      3
                      5
                      2
                      6
                      13
                    ]
                    typeFacets: {}
                    isPermissive: false
                  }
                }
                {
                  name: 'id'
                  value: {
                    Name: applicationInsightsName
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: resourceGroup().name
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
              ]
#disable-next-line BCP036
              type: 'Extension/AppInsightsExtension/PartType/MetricsExplorerBladePinnedPart'
#disable-next-line BCP037
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
#disable-next-line BCP037
              defaultMenuItemId: 'browser'
            }
          }
          {
            position: {
              x: 0
              y: 2
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'sessions/count'
                          aggregationType: 5
                          namespace: 'microsoft.insights/components/kusto'
                          metricVisualization: {
                            displayName: 'Sessions'
                            color: '#47BDF5'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'users/count'
                          aggregationType: 5
                          namespace: 'microsoft.insights/components/kusto'
                          metricVisualization: {
                            displayName: 'Users'
                            color: '#7E58FF'
                          }
                        }
                      ]
                      title: 'Unique sessions and users'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          extensionName: 'HubsExtension'
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                            menuid: 'segmentationUsers'
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 4
              y: 2
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'requests/failed'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Failed requests'
                            color: '#EC008C'
                          }
                        }
                      ]
                      title: 'Failed requests'
                      visualization: {
                        chartType: 3
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          extensionName: 'HubsExtension'
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                            menuid: 'failures'
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 8
              y: 2
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'requests/duration'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Server response time'
                            color: '#00BCF2'
                          }
                        }
                      ]
                      title: 'Server response time'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          extensionName: 'HubsExtension'
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                            menuid: 'performance'
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 12
              y: 2
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'browserTimings/networkDuration'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Page load network connect time'
                            color: '#7E58FF'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'browserTimings/processingDuration'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Client processing time'
                            color: '#44F1C8'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'browserTimings/sendDuration'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Send request time'
                            color: '#EB9371'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'browserTimings/receiveDuration'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Receiving response time'
                            color: '#0672F1'
                          }
                        }
                      ]
                      title: 'Average page load time breakdown'
                      visualization: {
                        chartType: 3
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 0
              y: 5
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'availabilityResults/availabilityPercentage'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Availability'
                            color: '#47BDF5'
                          }
                        }
                      ]
                      title: 'Average availability'
                      visualization: {
                        chartType: 3
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          extensionName: 'HubsExtension'
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                            menuid: 'availability'
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 4
              y: 5
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'exceptions/server'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Server exceptions'
                            color: '#47BDF5'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'dependencies/failed'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Dependency failures'
                            color: '#7E58FF'
                          }
                        }
                      ]
                      title: 'Server exceptions and Dependency failures'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 8
              y: 5
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'performanceCounters/processorCpuPercentage'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Processor time'
                            color: '#47BDF5'
                          }
                        }
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'performanceCounters/processCpuPercentage'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Process CPU'
                            color: '#7E58FF'
                          }
                        }
                      ]
                      title: 'Average processor and process CPU utilization'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 12
              y: 5
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'exceptions/browser'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Browser exceptions'
                            color: '#47BDF5'
                          }
                        }
                      ]
                      title: 'Browser exceptions'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 0
              y: 8
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'availabilityResults/count'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Availability test results count'
                            color: '#47BDF5'
                          }
                        }
                      ]
                      title: 'Availability test results count'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 4
              y: 8
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'performanceCounters/processIOBytesPerSecond'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Process IO rate'
                            color: '#47BDF5'
                          }
                        }
                      ]
                      title: 'Average process I/O rate'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 8
              y: 8
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Insights/components', applicationInsightsName)
                          }
                          name: 'performanceCounters/memoryAvailableBytes'
                          aggregationType: 4
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Available memory'
                            color: '#47BDF5'
                          }
                        }
                      ]
                      title: 'Average available memory'
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                    }
                  }
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
#disable-next-line BCP036
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
        ]
      }
    ]
  }
  tags: {
    'hidden-title': '${applicationInsightsDashboardTitle} Dashboard'
  }
}

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'ObjInt'

@description('The external Log Analytics Workspace to connect to, if blank a local workspace will be created, defaults to blank.')
param logAnalyticsWorkspaceResourceId string = ''

var logAnalyticsWorkspace = 'demo-${environment}-${location}-law'
var applicationInsightsName = 'demo-${environment}-${location}-appi'
var appServiceName = 'demo-${environment}-${location}-as'
var appServicePlanName = 'demo-${environment}-${location}-asp'
var LogAnalyticsWorkspaceResourceId = empty(logAnalyticsWorkspaceResourceId) ? LogAnalyticsWorkspace.id : logAnalyticsWorkspaceResourceId

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = if(empty(logAnalyticsWorkspaceResourceId)) {
  name: logAnalyticsWorkspace
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    features: {
      disableLocalAuth: true
    }
  }
}

resource ApplicationInsights 'Microsoft.Insights/components@2020-02-02' =  {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: LogAnalyticsWorkspaceResourceId
  }
}

module ApplicationInsightsDashboard './ApplicationInsightsDashboard.bicep' = {
  name: 'ApplicationInsightsDashboard/${deployment().name}'
  params: {
    applicationInsightsDashboardTitle: applicationInsightsName
    applicationInsightsDashboardName: '${ApplicationInsights.properties.AppId}-dashboard'
    applicationInsightsName: applicationInsightsName
    resourceLocation: location
  }
}

resource AppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    size: 'B1'
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource AppService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${appServiceName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${appServiceName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: AppServicePlan.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {}
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
  }
  identity: {
    type: 'SystemAssigned'
  }

  resource Web 'config' = {
    name: 'web'
    properties: {
      numberOfWorkers: 1
      defaultDocuments: [
        'Default.htm'
        'Default.html'
        'Default.asp'
        'index.htm'
        'index.html'
        'iisstart.htm'
        'default.aspx'
        'index.php'
        'hostingstart.html'
      ]
      netFrameworkVersion: 'v4.0'
      requestTracingEnabled: false
      remoteDebuggingEnabled: false
      remoteDebuggingVersion: 'VS2022'
      httpLoggingEnabled: false
      logsDirectorySizeLimit: 35
      detailedErrorLoggingEnabled: false
      publishingUsername: '$KeithDrewNet'
      azureStorageAccounts: {}
      scmType: 'VSTSRM'
      use32BitWorkerProcess: true
      webSocketsEnabled: false
      alwaysOn: true
      managedPipelineMode: 'Integrated'
      virtualApplications: [
        {
          virtualPath: '/'
          physicalPath: 'site\\wwwroot'
          preloadEnabled: true
        }
      ]
      autoHealEnabled: false
      localMySqlEnabled: false
      ipSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 1
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 1
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictionsUseMain: false
      http20Enabled: false
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }

  resource AppSettings 'config' = {
    name: 'appsettings'
    properties: {
      APPINSIGHTS_INSTRUMENTATIONKEY: ApplicationInsights.properties.InstrumentationKey
      APPLICATIONINSIGHTS_CONNECTION_STRING: ApplicationInsights.properties.ConnectionString
      ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
      XDT_MicrosoftApplicationInsights_Mode: 'recommended'
      APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
      DiagnosticServices_EXTENSION_VERSION: '~3'
      APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
      SnapshotDebugger_EXTENSION_VERSION: 'disabled'
      InstrumentationEngine_EXTENSION_VERSION: 'disabled'
      XDT_MicrosoftApplicationInsights_BaseExtensions: 'disabled'
      XDT_MicrosoftApplicationInsights_PreemptSdk: 'disabled'
      XDT_MicrosoftApplicationInsights_Java: '1'
      XDT_MicrosoftApplicationInsights_NodeJS: '1'
    }
  }

  resource HostNameBindings 'hostNameBindings' = {
    name: '${AppService.name}.azurewebsites.net'
    properties: {
      siteName: AppService.name
      hostNameType: 'Verified'
    }
  }
}

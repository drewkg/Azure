@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'ObjInt'

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param resourceLocation string = resourceGroup().location

var environment_var = environment
var applicationInsightsName_var = '${environment_var}-appi'
var appServiceName_var = '${environment_var}-as'
var appServicePlanName_var = '${environment_var}-asp'

resource applicationInsightsName 'microsoft.insights/components@2015-05-01' = {
  name: applicationInsightsName_var
  location: resourceLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    RetentionInDays: 90
  }
}

module ApplicationInsightsDashboard './nested_ApplicationInsightsDashboard.bicep' = {
  name: 'ApplicationInsightsDashboard'
  params: {
    applicationInsightsDashboardName: '${reference(applicationInsightsName.id, '2015-05-01', 'Full').properties.AppId}-dashboard'
    applicationInsightsName: applicationInsightsName_var
    resourceLocation: resourceLocation
  }
}

resource appServicePlanName 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appServicePlanName_var
  location: resourceLocation
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
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

resource appServiceName 'Microsoft.Web/sites@2018-11-01' = {
  name: appServiceName_var
  location: resourceLocation
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${appServiceName_var}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${appServiceName_var}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: appServicePlanName.id
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
}

resource appServiceName_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${appServiceName.name}/web'
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
    remoteDebuggingVersion: 'VS2019'
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
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
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

resource appServiceName_appsettings 'Microsoft.Web/sites/config@2020-09-01' = {
  name: '${appServiceName.name}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: reference(applicationInsightsName.id, '2015-05-01').InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: 'InstrumentationKey=${reference(applicationInsightsName.id, '2015-05-01').InstrumentationKey};IngestionEndpoint=https://uksouth-0.in.applicationinsights.azure.com/'
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

resource appServiceName_appServiceName_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2018-11-01' = {
  name: '${appServiceName.name}/${appServiceName_var}.azurewebsites.net'
  properties: {
    siteName: appServiceName_var
    hostNameType: 'Verified'
  }
}

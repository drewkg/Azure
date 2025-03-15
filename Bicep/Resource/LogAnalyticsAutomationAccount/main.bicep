@description('URI to artifacts location')
param _artifactsLocation string = substring(deployment().properties.templateLink.uri, 0, lastIndexOf(deployment().properties.templateLink.uri, '/'))

@secure()
param _artifactsLocationSasToken string = ''

@description('The location of the resources created, this is limited to only the locations that support linked Log Analytics and Automation Account.')
@allowed([
  'EastUS'
  'EastUS2'
  'WestUS'
  'WestUS2'
  'NorthCentralUS'
  'CentralUS'
  'SouthCentralUS'
  'WestCentralUS'
  'BrazilSouth'
  'CanadaCentral'
  'EastAsia'
  'SouthEastAsia'
  'CentralIndia'
  'JapanEast'
  'AustraliaEast'
  'AustraliaSouthEast'
  'KoreaCentral'
  'NorwayEast'
  'NorthEurope'
  'WestEurope'
  'FranceCentral'
  'UKSouth'
  'SwitzerlandNorth'
  'UAENorth'
])
param location string = 'UKSouth'

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(10)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

var automationAccountName = '${application}-${environment}-${automationAccountLocation}-aa'
var automationAccountLocation = (location == 'EastUS') ? 'EastUS2' : (location == 'EastUS2') ? 'EastUS' : location

output Subscription string = subscription().subscriptionId
output ResourceGroup string = resourceGroup().name
output LogAnalyticsWorkspaceName string = ResourceConventions.outputs.ResourceName.LogAnalyticsWorkspace
output AutomationAccountName string = ResourceConventions.outputs.ResourceName.automationAccount

module ResourceConventions '../../Modules/Guardrails/Objects.V1/ResouceNaming.Objects.V1.bicep' = {
  name: 'ResourceConventions'
  params: {
    application: application
    environment: environment
    location: location
  }
}

module LogAnalyticsWorkspace './LogAnalyticsWorkspace.bicep' = {
  name: 'LogAnalyticsWorkspaceDeployment'
  params: {
    location: ResourceConventions.outputs.Location
    resourceName: ResourceConventions.outputs.ResourceName.LogAnalyticsWorkspace
  }
}

module AutomationAccount './AutomationAccount.bicep' = {
  name: 'AutomationAccountDeployment'
  params: {
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: ResourceConventions.outputs.Location
    automationAccountResourceName: automationAccountName
    logAnalyticsWorkspaceResourceName: ResourceConventions.outputs.ResourceName.LogAnalyticsWorkspace
  }
}

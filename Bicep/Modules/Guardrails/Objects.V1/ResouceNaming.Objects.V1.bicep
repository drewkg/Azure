metadata info = {
  title: 'ResourceNaming.Objects.V1'
  description: 'Implements a central control point for applying to the Objects V1 Azure Resource Naming Convention, see https://github.com/drewkg/Azure/blob/main/docs/Conventions.md'
  version: '0.1.0'
  author: 'Keith Drew'
}

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(10)
param application string

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
@allowed([
  'ephemeral'
  'development'
  'test'
  'useracceptance'
  'preproduction'
  'production'
])
param environment string

@description('Utilized in ephemeral environments to generate a unqiue key for every deployment, if performing a redeployment care should be taken to ensure this is unique.')
param ephemeralKey string = newGuid()

@description('The location of the resources to be created or modified.')
@allowed([
  'BrazilSouth'
  'BrazilSoutheast'
  'CanadaCentral'
  'CanadaEast'
  'CentralUS'
  'EastUS'
  'EastUS2'
  'SouthCentralUS'
  'NorthCentralUS'
  'WestCentralUS'
  'WestUS'
  'WestUS2'
  'WestUS3'
  'AustraliaEast'
  'AustraliaCentral'
  'AustraliaCentral2'
  'AustraliaSouthEast'
  'EastAsia'
  'SouthEastAsia'
  'CentralIndia'
  'JioIndiaWest'
  'JioIndiaCentral'
  'SouthIndia'
  'WestIndia'
  'JapanEast'
  'JapanWest'
  'KoreaCentral'
  'KoreaSouth'
  'SouthAfricaNorth'
  'SouthAfricaWest'
  'WestEurope'
  'NorthEurope'
  'FranceCentral'
  'FranceSouth'
  'GermanyWestCentral'
  'GermanyNorth'
  'NorwayEast'
  'NorwayWest'
  'SwitzerlandNorth'
  'SwitzerlandWest'
  'SwedenCentral'
  'UKSouth'
  'UKWest'
  'UAECentral'
  'UAENorth'
  'UnitedArabEmirates'
])
param location string

var EnvironmentAbbreviation = {
  ephemeral: substring(guid(ephemeralKey), 0, 6)
  development: 'dev'
  test: 'tst'
  useracceptance: 'uat'
  preproduction: 'pre'
  production: 'prd'
}

var LocationAbbreviation = {
  Global: 'gbl'
  BrazilSouth: 'bso'
  BrazilSoutheast: 'bse'
  CanadaCentral: 'cac'
  CanadaEast: 'cae'
  CentralUS: 'cus'
  EastUS: 'eus'
  EastUS2: 'eus2'
  SouthCentralUS: 'scus'
  NorthCentralUS: 'ncus'
  WestCentralUS: 'wcus'
  WestUS: 'wus'
  WestUS2: 'wus2'
  WestUS3: 'wus3'
  AustraliaEast: 'aue'
  AustraliaCentral: 'auc'
  AustraliaCentral2: 'auc2'
  AustraliaSouthEast: 'ause'
  EastAsia: 'ea'
  SouthEastAsia: 'sea'
  CentralIndia: 'cin'
  JioIndiaWest: 'jwin'
  JioIndiaCentral: 'jcin'
  SouthIndia: 'sin'
  WestIndia: 'win'
  JapanEast: 'jpe'
  JapanWest: 'jpw'
  KoreaCentral: 'krc'
  KoreaSouth: 'krs'
  SouthAfricaNorth: 'san'
  SouthAfricaWest: 'saw'
  WestEurope: 'weu'
  NorthEurope: 'neu'
  FranceCentral: 'frc'
  FranceSouth: 'frs'
  GermanyWestCentral: 'gwc'
  GermanyNorth: 'gen'
  NorwayEast: 'nwe'
  NorwayWest: 'nww'
  SwitzerlandNorth: 'szn'
  SwitzerlandWest: 'szw'
  SwedenCentral: 'swc'
  UKSouth: 'uks'
  UKWest: 'ukw'
  UAECentral: 'uac'
  UAENorth: 'uan'
  UnitedArabEmirates: 'uae'
}

@description('The unique key for the environment, if ephemeral environment is selected this will be generated from the ephemeralKey parameter.')
output EnvironmentKey string = EnvironmentAbbreviation[environment]

@description('The location of the Azure resource.')
output Location string = toLower(location)
output LocationAbbreviation object = LocationAbbreviation

output ResourceName object = {
  ResourceGroup: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-rg'

  AppService: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-as'
  AppServicePlan: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-asp'
  AutomationAccount: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-aa'
  KeyVault: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-kv'
  LogAnalyticsWorkspace: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-log'
  StorageAccount: '${application}${EnvironmentAbbreviation[environment]}${LocationAbbreviation[location]}sa'
  SqlServer: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-sql'
  VirtualNetwork: '${application}-${EnvironmentAbbreviation[environment]}-${LocationAbbreviation[location]}-vnet'
}

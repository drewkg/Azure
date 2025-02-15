@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(10)
param application string

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
@allowed([
  'ephemeral'
  'development'
  'test'
  'pre-production'
  'production'
])
param environment string

@description('Utilized in Ephemeral Environments to generate a unqiue key for every environment, if performing a redeployment care should be taken to ensure this is unique.')
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
param location string = 'UKSouth'

@description('Generates a unique key for the environment, if ephemeral environment is selected this will be a substring of the ephemeralKey.')
var EnvironmentKey = (environment == 'ephemeral' ? substring(guid(ephemeralKey), 0, 8) : environment)

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

output EphemeralKey string = EnvironmentKey
output Location string = toLower(location)
output LocationAbbreviation object = LocationAbbreviation

output ResourceName object = {
  resourceGroup: '${application}-${EnvironmentKey}-${LocationAbbreviation[location]}-rg'
  automationAccount: '${application}-${EnvironmentKey}-${LocationAbbreviation[location]}-aa'
  logAnalyticsWorkspace: '${application}-${EnvironmentKey}-${LocationAbbreviation[location]}-law'
  appServicePlan: '${application}-${EnvironmentKey}-${LocationAbbreviation[location]}-asp'
  appService: '${application}-${EnvironmentKey}-${LocationAbbreviation[location]}-as'
  storageAccount: '${application}${EnvironmentKey}${LocationAbbreviation[location]}sa'
}

@minLength(1)
@description('Array of geographic locations to create a network watcher resource in.')
@allowed([
  'eastasia'
  'southeastasia'
  'centralus'
  'eastus'
  'eastus2'
  'westus'
  'westcentralus'
  'westus2'
  'westus3'
  'northcentralus'
  'southcentralus'
  'northeurope'
  'westeurope'
  'japanwest'
  'japaneast'
  'brazilsouth'
  'australiaeast'
  'australiasoutheast'
  'southindia'
  'centralindia'
  'westindia'
  'canadacentral'
  'canadaeast'
  'uksouth'
  'ukwest'
  'koreacentral'
  'koreasouth'
  'francecentral'
  'francesouth'
  'australiacentral'
  'australiacentral2'
  'uaecentral'
  'uaenorth'
  'southafricanorth'
  'southafricawest'
  'switzerlandnorth'
  'switzerlandwest'
  'germanynorth'
  'germanywestcentral'
  'norwaywest'
  'norwayeast'
  'brazilsoutheast'
])
param Locations array = [
  'uksouth'
]

resource networkWatcher 'Microsoft.Network/networkWatchers@2020-11-01' = [for location in Locations: {
  name: 'demo-general-${location}-nw'
  location: location
  properties: {}
}]

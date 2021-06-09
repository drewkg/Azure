@minLength(1)
@description('Array of geographic locations to create a network watcher resource in.')
param Locations array = [
  'uksouth'
]

resource networkWatcher 'Microsoft.Network/networkWatchers@2020-11-01' = [for location in Locations: {
  name: '${location}-nw'
  location: location
  properties: {}
}]

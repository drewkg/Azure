@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

param subnetId string
param ipPrefixName string = ''

var firewallName = '${application}-${environment}-${location}-afw'

resource IpPrefix 'Microsoft.Network/publicIPPrefixes@2024-03-01' existing = if(!empty(ipPrefixName)) {
  name: ipPrefixName
}

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  location: 'string'
  name: 'string'
  properties: {
    publicIPPrefix: {
      id: empty(ipPrefixName) ? null : IpPrefix.id
    }
  }
}

resource Firewall 'Microsoft.Network/azureFirewalls@2024-03-01' = {
  name: firewallName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConfig'
        properties: {
          publicIPAddress: {
            id: PublicIpAddress.id
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

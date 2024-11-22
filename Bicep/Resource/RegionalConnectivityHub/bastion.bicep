@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

@description('The resource group containing the virtual network resource, defaults to the current resource group.')
param vnetResourceGroup string = resourceGroup().name

@description('The name of the virtual network resource to link the Bastion to, no default.')
param vnetName string

@description('The name of the IP Prefix resource to link the Bastion VIP to, defaults to empty.')
param ipPrefixName string = ''

var bastionHostName = '${application}-${environment}-${location}-bas'
var publicIpName = '${application}-${environment}-${location}-pip-bastion'

resource IpPrefix 'Microsoft.Network/publicIPPrefixes@2024-03-01' existing = if(!empty(ipPrefixName)) {
  name: ipPrefixName
}

resource VNet 'Microsoft.Network/virtualNetworks@2024-03-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)

  resource AzureBastionSubnet 'subnets' existing = {
    name: 'AzureBastionSubnet'
  }
}

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPPrefix: {
      id: empty(ipPrefixName) ? null : IpPrefix.id
    }
  }
}

resource BastionHost 'Microsoft.Network/bastionHosts@2024-03-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: VNet::AzureBastionSubnet.id
          }
          publicIPAddress: {
            id: PublicIpAddress.id
          }
        }
      }
    ]
  }
}

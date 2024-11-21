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

@description('The name of the virtual network to link the Dns resolver to, no default. ')
param vnetName string

var dnsResolverName = '${application}-${environment}-${location}-dnspr'
var dnsInboundEndpoint = '${application}-${environment}-${location}-in'
var dnsOutboundEndpoint = '${application}-${environment}-${location}-out'
var forwardingRulesetName = '${application}-${environment}-${location}-dnsfr'
var resolvervnetlink = '${application}-${environment}-${location}-dnsfrlnk'

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)

  resource DNSInboundSubnet 'subnets@2024-03-01' existing = {
    name: 'DNSInboundSubnet'
  }

  resource DNSOutboundSubnet 'subnets@2024-03-01' existing = {
    name: 'DNSOutboundSubnet'
  }
}

resource dnsResolver 'Microsoft.Network/dnsResolvers@2023-07-01-preview' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
  }

  resource inboundEndpoint 'inboundEndpoints' = {
    name: dnsInboundEndpoint
    location: location
    properties: {
      ipConfigurations: [
        {
          privateIpAllocationMethod: 'dynamic'
          subnet: {
            id: vnet::DNSInboundSubnet.id
          }
        }
      ]
    }
  }

  resource outboundEndpoint 'outboundEndpoints' = {
    name: dnsOutboundEndpoint
    location: location
    properties: {
      subnet: {
        id: vnet::DNSOutboundSubnet.id
      }
    }
  }
}

resource fwruleSet 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' = {
  name: forwardingRulesetName
  location: location
  properties: {
    dnsResolverOutboundEndpoints: [
      {
        id: dnsResolver::outboundEndpoint.id
      }
    ]
  }

  resource resolverLink 'virtualNetworkLinks' = {
    name: resolvervnetlink
    properties: {
      virtualNetwork: {
        id: vnet.id
      }
    }
  }
}

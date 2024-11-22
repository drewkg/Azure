// @description('URI to artifacts location')
// param _artifactsLocation string = substring(deployment().properties.templateLink.uri, 0, lastIndexOf(deployment().properties.templateLink.uri, '/'))

// @secure()
// param _artifactsLocationSasToken string = ''

@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

@description('Array of CIDR ranges for the virtual network address space, CIDR /24 leaves a /26 available for future use cases.')
param vnetAddressCidr array = ['10.0.0.0/24']

var hubVNetName = '${application}-${environment}-${location}-vnet'
var azureFirewallRouteTableName = '${application}-${environment}-${location}-rt-azurefirewall'
var azureBastionSecurityGroupName = '${application}-${environment}-${location}-nsg-azurebastion'
var DNSInboundSecurityGroupName = '${application}-${environment}-${location}-nsg-dnsinbound'
var DNSOutboundSecurityGroupName = '${application}-${environment}-${location}-nsg-dnsoutbound'

var vnetCidrRanges = {
  AzureFirewallSubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 26, 0)
  AzureBastionSubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 26, 1)
  GatewaySubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 27, 4)
  RouteServerSubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 27, 5)
  DNSInboundSubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 28, 12)
  DNSOutboundSubnet: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 28, 13)
}

resource hubVNet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: hubVNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressCidr
    }
  }

  // CIDR /26 minimum - https://learn.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal
  resource AzureFirewallSubnet 'subnets' = {
    name: 'AzureFirewallSubnet'
    properties: {
      addressPrefix: vnetCidrRanges.AzureFirewallSubnet
      routeTable: {
        id: AzureFirewallRouteTable.id
      }
    }
  }

  // CIDR /26 minimum - https://learn.microsoft.com/en-us/azure/bastion/bastion-faq
  resource AzureBastionSubnet 'subnets' = {
    name: 'AzureBastionSubnet'
    properties: {
      addressPrefix: vnetCidrRanges.AzureBastionSubnet
      networkSecurityGroup: {
        id: AzureBastionSecurityGroup.id
      }
    }

    dependsOn: [
      hubVNet::AzureFirewallSubnet
    ]
  }

  // CIDR /27 recommended - https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings
  resource GatewaySubnet 'subnets' = {
    name: 'GatewaySubnet'
    properties: {
      addressPrefix: vnetCidrRanges.GatewaySubnet
    }

    dependsOn: [
      hubVNet::AzureBastionSubnet
    ]
  }

  // CIDR /27 recommended - https://learn.microsoft.com/en-us/azure/route-server/quickstart-create-route-server-portal
  resource RouteServerSubnet 'subnets' = {
    name: 'RouteServerSubnet'
    properties: {
      addressPrefix: vnetCidrRanges.RouteServerSubnet
    }

    dependsOn: [
      hubVNet::AzureBastionSubnet
    ]
  }

  // CIDR /28 recommended - https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture
  resource DNSInboundSubnet 'subnets' = {
    name: 'DNSInboundSubnet'
    properties: {
      addressPrefix: vnetCidrRanges.DNSInboundSubnet
      delegations: [
        {
          name: 'Microsoft.Network.dnsResolvers'
          properties: {
            serviceName: 'Microsoft.Network/dnsResolvers'
          }
        }
      ]
      networkSecurityGroup: {
        id: DNSInboundSecurityGroup.id
      }
    }

    dependsOn: [
      hubVNet::RouteServerSubnet
    ]
  }

  // CIDR /28 recommended - https://learn.microsoft.com/en-us/azure/dns/private-resolver-architecture
  resource DNSOutboundSubnet 'subnets' = {
    name: 'DNSOutboundSubnet'
    properties: {
      addressPrefix: vnetCidrRanges.DNSOutboundSubnet
      delegations: [
        {
          name: 'Microsoft.Network.dnsResolvers'
          properties: {
            serviceName: 'Microsoft.Network/dnsResolvers'
          }
        }
      ]
      networkSecurityGroup: {
        id: DNSOutboundSecurityGroup.id
      }
    }

    dependsOn: [
      hubVNet::DNSInboundSubnet
    ]
  }
}

resource AzureFirewallRouteTable 'Microsoft.Network/routeTables@2024-03-01' = {
  name: azureFirewallRouteTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'internet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'RFC1918_1'
        properties: {
          addressPrefix: '10.0.0.0/8'
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'RFC1918_2'
        properties: {
          addressPrefix: '172.16.0.0/12'
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'RFC1918_3'
        properties: {
          addressPrefix: '192.168.0.0/16'
          nextHopType: 'VnetLocal'
        }
      }
    ]
  }
}

resource AzureBastionSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: azureBastionSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource DNSInboundSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: DNSInboundSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowTagDNS-TCPInbound'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: vnetCidrRanges.DNSInboundSubnet
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowTagDNS-UDPInbound'
        properties: {
          protocol: 'UDP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: vnetCidrRanges.DNSInboundSubnet
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAll-Inbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowTagDNS-TCPOutbound'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: vnetCidrRanges.DNSInboundSubnet
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowTagDNS-UDPOutbound'
        properties: {
          protocol: 'UDP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: vnetCidrRanges.DNSInboundSubnet
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAll-Outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 120
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource DNSOutboundSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: DNSOutboundSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowTagDNS-TCPInbound'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: vnetCidrRanges.DNSOutboundSubnet
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowTagDNS-UDPInbound'
        properties: {
          protocol: 'UDP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: vnetCidrRanges.DNSOutboundSubnet
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAll-Inbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowTagDNS-TCPOutbound'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: vnetCidrRanges.DNSOutboundSubnet
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowTagDNS-UDPOutbound'
        properties: {
          protocol: 'UDP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: vnetCidrRanges.DNSOutboundSubnet
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAll-Outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 120
          direction: 'Outbound'
        }
      }
    ]
  }
}

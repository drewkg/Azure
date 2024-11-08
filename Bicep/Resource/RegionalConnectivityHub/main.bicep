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

@description('Array of CIDR ranges for the virtual network address space.')
param vnetAddressCidr array = ['10.0.0.0/8']

var hubVNetName = '${application}-${environment}-${location}-aa'

resource hubVNet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: hubVNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressCidr
    }
  }
}

resource GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' = {
  name: 'GatewaySubnet'
  parent: hubVNet
  properties: {
    addressPrefix: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 27, 0)
  }
}

resource AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' = {
  name: 'AzureFirewallSubnet'
  parent: hubVNet
  properties: {
    addressPrefix: cidrSubnet(hubVNet.properties.addressSpace.addressPrefixes[0], 27, 1)
  }
}





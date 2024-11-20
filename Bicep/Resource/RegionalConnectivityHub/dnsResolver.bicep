@description('The location of the resources created, excluding \'Global\', defaults to the resource group location.')
param location string = resourceGroup().location

@description('The application prefix, used within resource naming to ensure grouping of resources within the Azure portal.')
@minLength(1)
@maxLength(15)
param application string = 'demo'

@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
param environment string = 'test'

var dnsResolverName = '${application}-${environment}-${location}-dnspr'

resource dnsResolver 'Microsoft.Network/dnsResolvers@2023-07-01-preview' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: 'string'
    }
  }
}

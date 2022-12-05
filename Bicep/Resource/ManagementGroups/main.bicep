targetScope = 'tenant'

@description('The root management group for creating the structure. Defaults to the tenant Id.')
param rootManagementGroup string = tenant().tenantId

@description('The intermediate Management Group, to prevent deployments to the Tenant Root Group.')
param itermediateMgName string = 'Objects'

@description('Defines if the tenant root group is configured for new Azure Subscriptions, defaults to \'false\'')
param secureTenant bool = false

var CorporateId = guid('${rootManagementGroup}-${itermediateMgName}')
var PlatformId = guid('${CorporateId}-Platform')
var ConnectivityId = guid('${PlatformId}-Connectivity')
var IdentityId = guid('${PlatformId}-Identity')
var ManagementId = guid('${PlatformId}-Management')
var LandingZonesId = guid('${CorporateId}-LandingZones')
var CorpLandingZonesId = guid('${LandingZonesId}-CorpLandingZones')
var OnlineLandingZonesId = guid('${LandingZonesId}-OnlineLandingZones')
var SandboxId = guid('${rootManagementGroup}-Sandbox')

resource RootMGResource 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: rootManagementGroup
  scope: tenant()
}

resource RootMGSettings 'Microsoft.Management/managementGroups/settings@2021-04-01' = if (secureTenant) {
  name: 'rootManagementGroup/default'
  properties: {
    defaultManagementGroup: SandboxMGResource.id
    requireAuthorizationForGroupCreation: true
  }
}

resource CorporateMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: CorporateId
  scope: tenant()
  properties: {
    displayName: itermediateMgName
    details: {
      parent: {
        id: RootMGResource.id
      }
    }
  }
}

resource PlatformMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: PlatformId
  scope: tenant()
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: CorporateMGResource.id
      }
    }
  }
}

resource ConnectivityMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: ConnectivityId
  scope: tenant()
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: PlatformMGResource.id
      }
    }
  }
}

resource IdentityMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: IdentityId
  scope: tenant()
  properties: {
    displayName: 'Identity'
    details: {
      parent: {
        id: PlatformMGResource.id
      }
    }
  }
}

resource ManagementMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: ManagementId
  scope: tenant()
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: PlatformMGResource.id
      }
    }
  }
}

resource LandingZonesMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: LandingZonesId
  scope: tenant()
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: CorporateMGResource.id
      }
    }
  }
}

resource CorporateLandingZonesMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: CorpLandingZonesId
  scope: tenant()
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: LandingZonesMGResource.id
      }
    }
  }
}

resource OnlineLandingZonesMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: OnlineLandingZonesId
  scope: tenant()
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: LandingZonesMGResource.id
      }
    }
  }
}

resource SandboxMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: SandboxId
  scope: tenant()
  properties: {
    displayName: 'Sandbox'
    details: {
      parent: {
        id: CorporateMGResource.id
      }
    }
  }
}

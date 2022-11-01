targetScope = 'tenant'

@description('The root management group for creating the structure. Defaults to the tenant Id.')
param rootManagementGroup string = tenant().tenantId

var CorporateId = guid('${rootManagementGroup}-Corporate')
var PlatformId = guid('${CorporateId}-Platform')
var ManagementId = guid('${PlatformId}-Management')
var LandingZonesId = guid('${CorporateId}-LandingZones')
var CorpLandingZonesId = guid('${LandingZonesId}-CorpLandingZones')
var OnlineLandingZonesId = guid('${LandingZonesId}-OnlineLandingZones')
var SandboxId = guid('${rootManagementGroup}-Sandbox')

resource RootMGResource 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: rootManagementGroup
  scope: tenant()
}

resource CorporateMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: CorporateId
  scope: tenant()
  properties: {
    displayName: 'Objects'
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

resource ManagementMGResource 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: ManagementId
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
        id: RootMGResource.id
      }
    }
  }
}

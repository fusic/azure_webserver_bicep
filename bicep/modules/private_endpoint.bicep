param appName string
param environment string
param subnetID string
param DBForPostgreSQLID string

var endpointName = '${appName}Endpoint${environment}'
var serviceConnectionName = '${appName}ServiceConnection${environment}'
var privateDnsZoneName = 'privatelink.postgres.database.azure.com'

resource endpoint 'Microsoft.Network/privateEndpoints@2020-08-01' = {
  name: endpointName
  location: resourceGroup().location
  properties: {
    subnet: {
      id: subnetID
    }
    privateLinkServiceConnections: [
      {
        properties: {
          privateLinkServiceId: DBForPostgreSQLID
          groupIds: [
            'postgresqlServer'
          ]
        }
        name: serviceConnectionName
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {}
}

resource privateDnsZoneName_postgresql 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${privateDnsZone.name}/postgresql'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: first(first(reference(endpointName).customDnsConfigs).ipAddresses)
      }
    ]
  }
}

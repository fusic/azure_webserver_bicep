param appName string
param environment string

var virtualNetworkName = '${appName}Vnet${environment}'
var gatewaySubnetName = '${appName}GatewaySubnet${environment}'
var publicSubnetName = '${appName}PublicSubnet${environment}'
var virtualNetworkID = virtualNetwork.id

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2016-03-30' = {
  name: virtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: gatewaySubnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: publicSubnetName
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output virtualNetworkID string = virtualNetworkID
output gatewaySubnetID string = '${virtualNetworkID}/subnets/${gatewaySubnetName}'
output publicSubnetID string = '${virtualNetworkID}/subnets/${publicSubnetName}'

param appName string
param environment string

var gatewayIPName = '${appName}GatewayIP${environment}'

resource gatewayIP 'Microsoft.Network/publicIPAddresses@2020-05-01' = {
  name: gatewayIPName
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

output gatewayIPID string = gatewayIP.id

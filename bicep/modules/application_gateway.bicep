param appName string
param environment string
param gatewaySubnetID string
param gatewayIPID string

var applicationGatewayName = '${appName}ApplicationGateway${environment}'
var gatewayIPConfigurationName = '${appName}GIPConfiguration${environment}'
var frontendIPConfigurationName = '${appName}FIPConfiguration${environment}'
var frontendIPPortName = '${appName}FIPPort${environment}'
var httpListenerName = '${appName}HTTPListener${environment}'
var backendAddressPoolName = '${appName}BAddressPool${environment}'
var backendHTTPSettingName = '${appName}BSetting${environment}'
var requestRoutingRuleName = '${appName}RRoutingRule${environment}'
var applicationGatewayID = resourceId('Microsoft.Network/applicationGateways', applicationGatewayName)
var frontendIPConfigurationID = '${applicationGatewayID}/frontendIPConfigurations/${frontendIPConfigurationName}'
var frontendIPPortID = '${applicationGatewayID}/frontendPorts/${frontendIPPortName}'
var httpListenerID = '${applicationGatewayID}/httpListeners/${httpListenerName}'
var backendAddressPoolID = '${applicationGatewayID}/backendAddressPools/${backendAddressPoolName}'
var backendHTTPSettingID = '${applicationGatewayID}/backendHttpSettingsCollection/${backendHTTPSettingName}'

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-08-01' = {
  name: applicationGatewayName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIPConfigurationName
        properties: {
          subnet: {
            id: gatewaySubnetID
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIPConfigurationName
        properties: {
          publicIPAddress: {
            id: gatewayIPID
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendIPPortName
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendAddressPoolName
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHTTPSettingName
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenerName
        properties: {
          frontendIPConfiguration: {
            id: frontendIPConfigurationID
          }
          frontendPort: {
            id: frontendIPPortID
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: requestRoutingRuleName
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: httpListenerID
          }
          backendAddressPool: {
            id: backendAddressPoolID
          }
          backendHttpSettings: {
            id: backendHTTPSettingID
          }
        }
      }
    ]
  }
}

output applicationGatewayID string = applicationGatewayID
output backendAddressPoolID string = backendAddressPoolID

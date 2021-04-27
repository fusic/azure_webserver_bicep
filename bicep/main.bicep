param appName string
param environment string
param dbName string
param dbUser string
param dbPassword string
param keyData string

var deploymentVirtualNetworkName = '${appName}CreateVirtualNetwork${environment}'
var deploymentGatewayIPName = '${appName}CreateGateway${environment}'
var deploymentApplicationGatewayName = '${appName}CreateApplicationGateway${environment}'
var deploymentVMSSName = '${appName}CreateVMSS${environment}'
var deploymentPostgreSQLName = '${appName}CreatePostgreSQL${environment}'
var deploymentPrivateEndpointName = '${appName}CreatePrivateEndpoint${environment}'
var deploymentStorageAccountName = '${appName}CreateStorageAccount${environment}'

module deploymentVirtualNetwork 'modules/virtual_network.bicep' = {
  name: deploymentVirtualNetworkName
  params: {
    appName: appName
    environment: environment
  }
}

module deploymentGatewayIP 'modules/public_ip_address.bicep' = {
  name: deploymentGatewayIPName
  params: {
    appName: appName
    environment: environment
  }
}

module deploymentApplicationGateway 'modules/application_gateway.bicep' = {
  name: deploymentApplicationGatewayName
  params: {
    appName: appName
    environment: environment
    gatewaySubnetID: deploymentVirtualNetwork.outputs.gatewaySubnetID
    gatewayIPID: deploymentGatewayIP.outputs.gatewayIPID
  }
}

module deploymentVMSS 'modules/virtual_machine_scale_set.bicep' = {
  name: deploymentVMSSName
  params: {
    appName: appName
    environment: environment
    publicSubnetID: reference(deploymentVirtualNetworkName).outputs.publicSubnetID.value
    backendAddressPoolID: reference(deploymentApplicationGatewayName).outputs.backendAddressPoolID.value
    keyData: keyData
  }
}

module deploymentPostgreSQL 'modules/database_for_postgresql.bicep' = {
  name: deploymentPostgreSQLName
  params: {
    appName: appName
    environment: environment
    dbName: dbName
    dbUser: dbUser
    dbPassword: dbPassword
  }
}

module deploymentPrivateEndpoint 'modules/private_endpoint.bicep' = {
  name: deploymentPrivateEndpointName
  params: {
    appName: appName
    environment: environment
    subnetID: reference(deploymentVirtualNetworkName).outputs.publicSubnetID.value
    DBForPostgreSQLID: reference(deploymentPostgreSQLName).outputs.DBforPostgreSQLID.value
  }
}

module deploymentStorageAccount 'modules/storage_account.bicep' = {
  name: deploymentStorageAccountName
  params: {
    appName: appName
    environment: environment
  }
}

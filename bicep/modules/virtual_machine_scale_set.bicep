param appName string
param environment string
param publicSubnetID string
param backendAddressPoolID string
param keyData string

var vmssName = '${appName}VMSS${environment}'
var ipConfigurationName = '${appName}IPConfigration${environment}'
var nicName = '${appName}NIC${environment}'

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2020-12-01' = {
  name: vmssName
  location: resourceGroup().location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    overprovision: true
    singlePlacementGroup: false
    upgradePolicy: {
      mode: 'Automatic'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
        dataDisks: []
        imageReference: {
          publisher: 'OpenLogic'
          offer: 'CentOS'
          sku: '7-CI'
          version: 'latest'
        }
      }
      osProfile: {
        adminUsername: 'azureuser'
        computerNamePrefix: vmssName
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: {
            publicKeys: [
              {
                path: '/home/azureuser/.ssh/authorized_keys'
                keyData: keyData
              }
            ]
          }
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: nicName
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: ipConfigurationName
                  properties: {
                    subnet: {
                      id: publicSubnetID
                    }
                    applicationGatewayBackendAddressPools: [
                      {
                        id: backendAddressPoolID
                      }
                    ]
                    publicIPAddressConfiguration: {
                      name: 'public_ip'
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

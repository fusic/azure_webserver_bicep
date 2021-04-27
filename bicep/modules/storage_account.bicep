param appName string
param environment string

var storageAccountName = toLower('${appName}Storage${environment}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
}

resource storageAccountName_default_image 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccount.name}/default/image'
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountID string = storageAccount.name

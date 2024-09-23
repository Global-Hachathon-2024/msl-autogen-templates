@description('The name of the storage account')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('The name of the storage container')
param containerName string = 'container${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccount.name}/default/${containerName}'
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountName string = storageAccount.name
output containerName string = storageContainer.name
output storageAccountConnectionString string = listKeys(storageAccount.id, '2022-09-01').keys[0].value
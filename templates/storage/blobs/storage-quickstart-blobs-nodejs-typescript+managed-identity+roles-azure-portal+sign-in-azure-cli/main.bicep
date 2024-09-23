@description('The name of the storage account')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('The location of the storage account')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountName string = storageAccount.name
output storageAccountConnectionString string = listKeys(storageAccount.id, '2022-09-01').keys[0].value
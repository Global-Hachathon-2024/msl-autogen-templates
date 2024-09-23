@description('The name of the Storage Account')
param storageAccountName string = 'st${uniqueString(resourceGroup().id)}'

@description('The location of the Storage Account')
param location string = resourceGroup().location

@description('The SKU of the Storage Account')
param storageAccountSkuName string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountName string = storageAccount.name
output storageAccountConnectionString string = listKeys(storageAccount.id, '2022-09-01').keys[0].value
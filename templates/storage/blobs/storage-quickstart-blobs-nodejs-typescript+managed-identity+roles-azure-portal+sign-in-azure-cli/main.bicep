@description('The name of the storage account')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('The location of the storage account')
param location string = resourceGroup().location

@description('The SKU of the storage account')
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
output storageAccountId string = storageAccount.id
output storageAccountPrimaryEndpoints object = storageAccount.properties.primaryEndpoints
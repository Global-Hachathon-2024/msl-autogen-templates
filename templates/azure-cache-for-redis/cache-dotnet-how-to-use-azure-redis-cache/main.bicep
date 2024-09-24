@description('The name of the Azure Cache for Redis instance.')
param redisCacheName string = 'redis-${uniqueString(resourceGroup().id)}'

@description('The location of the Azure Cache for Redis instance.')
param location string = resourceGroup().location

@description('The SKU of the Azure Cache for Redis instance.')
param skuName string = 'Standard'

@description('The size of the Azure Cache for Redis instance.')
param skuFamily string = 'C'

@description('The capacity of the Azure Cache for Redis instance.')
param skuCapacity int = 1

resource redisCache 'Microsoft.Cache/Redis@2023-08-01' = {
  name: redisCacheName
  location: location
  sku: {
    name: skuName
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
  }
}

output redisHostName string = redisCache.properties.hostName
output redisPrimaryKey string = listKeys(redisCache.id, '2023-08-01').primaryKey
@description('The name of the web app that you wish to create.')
param webAppName string

@description('The location where the resources will be deployed.')
param location string = resourceGroup().location

@description('The SKU of the App Service plan.')
param skuName string = 'F1'

@description('The Node.js version to use.')
param nodeVersion string = '18-lts'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${webAppName}-plan'
  location: location
  sku: {
    name: skuName
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: nodeVersion
        }
      ]
    }
  }
}

output webAppName string = webApp.name
output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
@description('The name of the Azure App Service plan.')
param appServicePlanName string = 'appServicePlan-${uniqueString(resourceGroup().id)}'

@description('The name of the web app.')
param webAppName string = 'webapp-${uniqueString(resourceGroup().id)}'

@description('The location of the resources.')
param location string = resourceGroup().location

@description('The SKU of the App Service plan.')
param skuName string = 'B1'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: 'Basic'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
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
      ]
    }
  }
}

output webAppName string = webApp.name
output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
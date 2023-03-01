@description('The Azure region into which the resources should be deployed.')
param location string

@description('The name of the App service app.')
param appServiceAppName string

@description('The name of the App Service plan.')
param appServicePlanName string

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string

@description('The App service to be deployed along with its SKU name.')
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  //resource Identifier 'Type' = {
    name: appServicePlanName
    location: location
    sku: {
      name: appServicePlanSkuName
    }
  //}
}

@description('The app service to be deployed.')
resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

@description('The default host name of the App service app.')
output appServiceAppHostName string = appServiceApp.properties.defaultHostName

param location string
param appServiceAppname string

@allowed([
  'dev'
  'prod'
])
param environmentType string

var appServicePlanName = 'toy-product-launch-plan'
var appServiceSkuName = (environmentType == 'prod') ? 'P2_v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServiceSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppname
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName

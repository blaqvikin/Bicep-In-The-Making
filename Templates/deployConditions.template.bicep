@description('The Azure region into which the resources should be deployed.')
param resourceLocation string

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorPassword string

@description('The name of the environment. This must be Development or Production.')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The name of the audit storage account SKU.')
param auditStorageAccountSkuName string = 'Standard_LRS'

@secure()
@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

var sqlServerName = 'reddy${resourceLocation}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeaddyBear'
var auditingEnabled = environmentName == 'Production'
var auditStorageAccountName = '${take('bearaudit${resourceLocation}${uniqueString(resourceGroup().id)}', 24)}'

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: sqlServerName
  location: resourceLocation
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: resourceLocation
  sku: sqlDatabaseSku
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: resourceLocation
  sku: {
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'
}

 resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2021-08-01-preview' = if (auditingEnabled) {
   parent: sqlServer
   name: 'default'
   properties: {
     state: 'Enabled'
     storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
     storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
   }
 }

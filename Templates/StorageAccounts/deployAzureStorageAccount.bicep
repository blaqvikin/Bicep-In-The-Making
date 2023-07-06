@description('Define the location the resources will be deployed in/')
param location string = resourceGroup().location

@description('Limit the length of the storage account name. Define storage generic name for storage account based on the given parameters.')
//@minLength(5)
@maxLength(12)
param storageAccountName string = 'mh${uniqueString(resourceGroup().id)}'

@allowed([
  'dev'
  'prod'
])

//If environment type equals tag at deployment, deploy a GRS enabled storage, else LRS
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

//Storage account creation.

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku:{
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
  //Provide tags
  tags: {
    IAC : 'Bicep'
    CreatedBy : 'MawandaH'
    Environment : 'Dev'
  }
}

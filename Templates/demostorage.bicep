resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'bicepdemosan1'
  location: 'southafricanorth'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

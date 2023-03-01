@description('The Cosmos DB account name.')
param cosmosDBAccountName string = '${uniqueString(resourceGroup().id)}-toyrnd'
@description('Location of the resources based on the resource group.')
param location string = resourceGroup().location
@description('The CosmosDB throughput')
param cosmosDBDatabaseThroughput int = 400

var cosmosDBDatabaseName = 'FlightTests'
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerPartitionKey = '/droneId'

@description('Deploying the CosmosDB.')
resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-11-15-preview' = {
  name: cosmosDBAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

@description('Deploying the CosmosDB.')
resource cosmosDBDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-11-15-preview' = {
  parent: cosmosDBAccount
  name: cosmosDBDatabaseName
  properties: {
    resource: {
      id: cosmosDBDatabaseName
    }
    options: {
      throughput: cosmosDBDatabaseThroughput
    }
  }
resource container 'containers' = {
  name: cosmosDBAccountName
  properties: {
    resource: {
      id: cosmosDBContainerName
      partitionKey: {
        kind: 'Hash'
        paths: [
          cosmosDBContainerPartitionKey
        ]
      }
    }
    options: {
      
    }
  }
}
}

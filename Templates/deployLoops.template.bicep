@description('The Azure region into which the resources should be deployed.')
param locations string = resourceGroup().location
@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

module databases '../modules/databases.bicep' = {
  name: 'database-${locations}'
  params: {
    location: locations
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
  }
  
}

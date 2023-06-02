@secure()
param sqlServerAdministratorLogin string
@secure()
param sqlServerAdministratorPassword string
param sqlDatabaseSku object

param environmentName string

var locations = resourceGroup().location
var sqlServerName = 'sql${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'Employees'

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: locations
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
  tags: {
    env: environmentName
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: locations
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
  tags: {
    env: environmentName
  }
}

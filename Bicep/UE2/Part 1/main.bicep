@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int

param appServicePlanSku object

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

var appServiceAppName = 'asa${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'asp${uniqueString(resourceGroup().id)}'
var locations = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: locations
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
  tags: {
    env: environmentName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: locations
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
  tags: {
    env: environmentName
  }
}

module database './modules/database.bicep' = {
  name: 'database'
  params: {
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
    sqlDatabaseSku: sqlDatabaseSku
    environmentName: environmentName
  }
}

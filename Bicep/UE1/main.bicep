param storageAccountName string = 'sa${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'asa${uniqueString(resourceGroup().id)}'
param locations string = resourceGroup().location
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: locations
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService './modules/app.bicep' = {
  name: 'appService'
  params: {
    locations: locations
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName

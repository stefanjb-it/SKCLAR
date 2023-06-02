@description('The Azure regions into which the resources should be deployed.')
param locations array

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

@description('The IP address range for all virtual networks to use.')
param virtualNetworkAddressPrefix string 

@description('The name and IP address range for each subnet in the virtual networks.')
param subnets array 

@description('The name of the environment. This must be dev or prod.')
@allowed([
  'dev'
  'prod'
])
param environmentName string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

module databases './modules/database.bicep' = [for location in locations: {
  name: 'db-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
    environmentName: environmentName
    sqlDatabaseSku: sqlDatabaseSku
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-08-01' = [for location in locations: {
  name: 'nw-${location}'
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]

output serverInfo array = [for i in range(0, length(locations)): {
  name: databases[i].outputs.serverName
  location: databases[i].outputs.location
  fullyQualifiedDomainName: databases[i].outputs.serverFullyQualifiedDomainName
}]

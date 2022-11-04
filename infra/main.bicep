targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var appName = take(replace(name, '-', ''), 35)
var prefix = '${resourceToken}${appName}'
var tags = { 'azd-env-name': name }

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}rg'
  location: location
  tags: tags
}

module loganalytics 'loganalytics.bicep' = {
  scope: resourceGroup
  name: 'loganalytics'
  params: {
    name: '${prefix}la'
    location: location
    tags: tags
  }
}

var appStorageAppName = take(replace(prefix, '-', ''), 17)
module storage 'storage.bicep' = {
  scope: resourceGroup
  name: 'storage'
  params: {
    location: location
    tags: tags
    name: '${appStorageAppName}storage'
  }
}

module appServicePlan 'appserviceplan.bicep'= {
  scope: resourceGroup
  name: 'appserviceplan'
  params: {
    location: location
    tags: tags
    name: '${prefix}appserviceplan'
    sku: {
      name: 'B1'
      tier: 'Basic'
    }
  }
}

module appService 'appservice.bicep' = {
  scope: resourceGroup
  name: 'appservice'
  params: {
    location: location
    tags: union(tags, { 'azd-service-name': 'web' })
    name: '${prefix}appservice'
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'python'
    runtimeVersion: '3.10'
    appSettings: {
      AZURE_STORAGE_QUEUE_NAME:'AzStorageQueueMessage' 
      AZURE_STORAGE_CONNECTION_STRING: storage.outputs.AZURE_STORAGE_CONNECTION_STRING
    }
  }
}


module appInsights 'applicationinsights.bicep' = {
  scope: resourceGroup
  name: 'appinsights'
  params: {
    logAnalyticsWorkspaceId: loganalytics.outputs.id
    dashboardName: '${prefix}dashboard'
    location: location
    tags: tags
    name: '${prefix}appinsights'
  }
}

output APPLICATIONINSIGHTS_CONNECTION_STRING string = appInsights.outputs.connectionString
output AZURE_LOCATION string = location

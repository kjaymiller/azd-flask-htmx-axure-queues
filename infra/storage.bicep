param name string
param location string = resourceGroup().location
param tags object = {}

param allowBlobPublicAccess bool = false
param kind string = 'StorageV2'
param minimumTlsVersion string = 'TLS1_2'
param sku object = { name: 'Standard_LRS' }

resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  sku: sku
  properties: {
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

var az_conn_string = 'DefaultEndpointsProtocol=https;AccountName=${name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storage.id, storage.apiVersion).keys[0].value}'
output name string = storage.name
output AZURE_STORAGE_CONNECTION_STRING string = az_conn_string

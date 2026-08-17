metadata name = 'Storage Account'
metadata description = 'Deploys an Azure Storage Account with secure defaults and optional blob containers.'
metadata owner = 'rioarijit-labs'

@description('Name of the storage account (3-24 lowercase alphanumeric characters).')
@minLength(3)
@maxLength(24)
param name string

@description('Azure region for the storage account.')
param location string = resourceGroup().location

@description('Storage account SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_RAGRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Storage account kind.')
@allowed([
  'StorageV2'
  'BlockBlobStorage'
  'FileStorage'
])
param kind string = 'StorageV2'

@description('Blob access tier.')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Minimum TLS version accepted by the storage account.')
param minimumTlsVersion string = 'TLS1_2'

@description('Blob containers to create. Each item: { name }.')
param containers array = []

@description('Resource tags to apply.')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }

  resource blobService 'blobServices@2023-05-01' = if (!empty(containers)) {
    name: 'default'

    resource blobContainers 'containers@2023-05-01' = [for container in containers: {
      name: container.name
      properties: {
        publicAccess: 'None'
      }
    }]
  }
}

@description('Resource ID of the storage account.')
output storageAccountId string = storageAccount.id

@description('Name of the storage account.')
output storageAccountName string = storageAccount.name

@description('Primary blob endpoint.')
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob

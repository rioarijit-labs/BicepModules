metadata name = 'AI Foundry Account'
metadata description = 'Deploys an Azure AI Foundry (Cognitive Services AIServices) account with optional model deployments.'
metadata owner = 'rioarijit-labs'

@description('Name of the AI Foundry account.')
param name string

@description('Azure region for the AI Foundry account.')
param location string = resourceGroup().location

@description('Pricing tier SKU.')
@allowed([
  'S0'
])
param skuName string = 'S0'

@description('Whether public network access is allowed.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Model deployments to create under this account. Each item: { name, modelName, modelVersion, skuName, capacity }.')
param modelDeployments array = []

@description('Resource tags to apply.')
param tags object = {}

resource aiFoundry 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: name
  location: location
  tags: tags
  kind: 'AIServices'
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: name
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: false
  }
}

resource deployments 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = [for deployment in modelDeployments: {
  parent: aiFoundry
  name: deployment.name
  sku: {
    name: deployment.skuName
    capacity: deployment.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.modelName
      version: deployment.modelVersion
    }
  }
}]

@description('Resource ID of the AI Foundry account.')
output aiFoundryId string = aiFoundry.id

@description('Name of the AI Foundry account.')
output aiFoundryName string = aiFoundry.name

@description('Endpoint of the AI Foundry account.')
output endpoint string = aiFoundry.properties.endpoint

@description('Principal ID of the system-assigned managed identity.')
output principalId string = aiFoundry.identity.principalId

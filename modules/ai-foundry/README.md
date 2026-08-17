# AI Foundry Account

Deploys an Azure AI Foundry account (`Microsoft.CognitiveServices/accounts`, kind `AIServices` —
the unified AI Foundry resource) with a system-assigned managed identity and optional model
deployments.

## Usage

```bicep
module aiFoundry 'br:ghcr.io/rioarijit-labs/bicep/ai-foundry:1.0.0' = {
  name: 'ai-foundry-deployment'
  params: {
    name: 'aif-prod-001'
    modelDeployments: [
      {
        name: 'gpt-4o-mini'
        modelName: 'gpt-4o-mini'
        modelVersion: '2024-07-18'
        skuName: 'Standard'
        capacity: 10
      }
    ]
  }
}
```

See [examples/main.bicep](examples/main.bicep) for a runnable example.

## Parameters

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | Yes | - | Name of the AI Foundry account. |
| `location` | string | No | `resourceGroup().location` | Azure region. |
| `skuName` | string | No | `S0` | Pricing tier SKU. |
| `publicNetworkAccess` | string | No | `Enabled` | `Enabled` or `Disabled`. |
| `modelDeployments` | array | No | `[]` | Model deployments: `{ name, modelName, modelVersion, skuName, capacity }`. |
| `tags` | object | No | `{}` | Resource tags. |

## Outputs

| Name | Type | Description |
|---|---|---|
| `aiFoundryId` | string | Resource ID of the AI Foundry account. |
| `aiFoundryName` | string | Name of the AI Foundry account. |
| `endpoint` | string | Account endpoint URL. |
| `principalId` | string | Principal ID of the system-assigned managed identity. |

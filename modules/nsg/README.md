# Network Security Group

Deploys a Network Security Group with configurable security rules.

## Usage

```bicep
module nsg 'br:ghcr.io/rioarijit-labs/bicep/nsg:1.0.0' = {
  name: 'nsg-deployment'
  params: {
    name: 'nsg-prod'
    securityRules: [
      {
        name: 'allow-https-inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
```

See [examples/main.bicep](examples/main.bicep) for a runnable example.

## Parameters

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | Yes | - | Name of the network security group. |
| `location` | string | No | `resourceGroup().location` | Azure region. |
| `securityRules` | array | No | `[]` | Security rules (native `securityRules` schema). |
| `tags` | object | No | `{}` | Resource tags. |

## Outputs

| Name | Type | Description |
|---|---|---|
| `nsgId` | string | Resource ID of the network security group. |
| `nsgName` | string | Name of the network security group. |

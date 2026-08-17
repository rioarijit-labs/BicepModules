# Virtual Network

Deploys an Azure Virtual Network with configurable subnets.

## Usage

```bicep
module vnet 'br:ghcr.io/rioarijit-labs/bicep/vnet:1.0.0' = {
  name: 'vnet-deployment'
  params: {
    name: 'vnet-prod'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'snet-app'
        addressPrefix: '10.0.0.0/24'
      }
    ]
  }
}
```

See [examples/main.bicep](examples/main.bicep) for a runnable example.

## Parameters

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | Yes | - | Name of the virtual network. |
| `location` | string | No | `resourceGroup().location` | Azure region. |
| `addressPrefixes` | array | Yes | - | Address space(s) in CIDR notation. |
| `subnets` | array | No | `[]` | Subnets: `{ name, addressPrefix, networkSecurityGroupId?, serviceEndpoints?, delegations? }`. |
| `tags` | object | No | `{}` | Resource tags. |

## Outputs

| Name | Type | Description |
|---|---|---|
| `vnetId` | string | Resource ID of the virtual network. |
| `vnetName` | string | Name of the virtual network. |
| `subnetIds` | object | Map of subnet name to subnet resource ID. |

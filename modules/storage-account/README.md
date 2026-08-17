# Storage Account

Deploys an Azure Storage Account with secure defaults (HTTPS-only, TLS 1.2 minimum,
no anonymous blob access) and optional blob containers.

## Usage

```bicep
module storageAccount 'br:ghcr.io/rioarijit-labs/bicep/storage-account:1.0.0' = {
  name: 'storage-deployment'
  params: {
    name: 'stprodapp001'
    containers: [
      {
        name: 'data'
      }
    ]
  }
}
```

See [examples/main.bicep](examples/main.bicep) for a runnable example.

## Parameters

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | Yes | - | Storage account name (3-24 lowercase alphanumeric characters). |
| `location` | string | No | `resourceGroup().location` | Azure region. |
| `skuName` | string | No | `Standard_LRS` | Storage SKU. |
| `kind` | string | No | `StorageV2` | Storage account kind. |
| `accessTier` | string | No | `Hot` | Blob access tier. |
| `minimumTlsVersion` | string | No | `TLS1_2` | Minimum TLS version accepted. |
| `containers` | array | No | `[]` | Blob containers to create: `{ name }`. |
| `tags` | object | No | `{}` | Resource tags. |

## Outputs

| Name | Type | Description |
|---|---|---|
| `storageAccountId` | string | Resource ID of the storage account. |
| `storageAccountName` | string | Name of the storage account. |
| `primaryBlobEndpoint` | string | Primary blob endpoint URL. |

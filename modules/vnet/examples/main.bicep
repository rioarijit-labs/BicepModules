// Example usage. Locally this references the module by relative path so CI
// can lint/build/what-if it before the module has ever been published.
// In a *consuming* repo, replace the `module` target with the registry
// reference shown in ../README.md.
module vnet '../main.bicep' = {
  name: 'vnet-example'
  params: {
    name: 'vnet-lab-${uniqueString(resourceGroup().id)}'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'snet-app'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'snet-data'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    tags: {
      environment: 'lab'
    }
  }
}

output vnetId string = vnet.outputs.vnetId

// Example usage. Locally this references the module by relative path so CI
// can lint/build/what-if it before the module has ever been published.
// In a *consuming* repo, replace the `module` target with the registry
// reference shown in ../README.md.
module storageAccount '../main.bicep' = {
  name: 'storage-example'
  params: {
    name: 'stlab${uniqueString(resourceGroup().id)}'
    containers: [
      {
        name: 'data'
      }
    ]
    tags: {
      environment: 'lab'
    }
  }
}

output storageAccountId string = storageAccount.outputs.storageAccountId

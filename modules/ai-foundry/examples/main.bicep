// Example usage. Locally this references the module by relative path so CI
// can lint/build/what-if it before the module has ever been published.
// In a *consuming* repo, replace the `module` target with the registry
// reference shown in ../README.md.
module aiFoundry '../main.bicep' = {
  name: 'ai-foundry-example'
  params: {
    name: 'aif-lab-${uniqueString(resourceGroup().id)}'
    modelDeployments: [
      {
        name: 'gpt-4o-mini'
        modelName: 'gpt-4o-mini'
        modelVersion: '2024-07-18'
        skuName: 'Standard'
        capacity: 10
      }
    ]
    tags: {
      environment: 'lab'
    }
  }
}

output aiFoundryId string = aiFoundry.outputs.aiFoundryId

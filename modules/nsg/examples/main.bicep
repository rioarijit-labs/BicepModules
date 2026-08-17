// Example usage. Locally this references the module by relative path so CI
// can lint/build/what-if it before the module has ever been published.
// In a *consuming* repo, replace the `module` target with the registry
// reference shown in ../README.md.
module nsg '../main.bicep' = {
  name: 'nsg-example'
  params: {
    name: 'nsg-lab-${uniqueString(resourceGroup().id)}'
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
    tags: {
      environment: 'lab'
    }
  }
}

output nsgId string = nsg.outputs.nsgId

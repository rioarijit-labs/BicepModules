metadata name = 'Virtual Network'
metadata description = 'Deploys an Azure Virtual Network with configurable subnets.'
metadata owner = 'rioarijit-labs'

@description('Name of the virtual network.')
param name string

@description('Azure region for the virtual network.')
param location string = resourceGroup().location

@description('Address space(s) for the virtual network, in CIDR notation.')
param addressPrefixes array

@description('Subnets to create within the virtual network. Each item: { name, addressPrefix, networkSecurityGroupId?, serviceEndpoints?, delegations? }')
param subnets array = []

@description('Resource tags to apply.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: contains(subnet, 'networkSecurityGroupId') && !empty(subnet.networkSecurityGroupId) ? {
          id: subnet.networkSecurityGroupId
        } : null
        serviceEndpoints: subnet.?serviceEndpoints ?? []
        delegations: subnet.?delegations ?? []
      }
    }]
  }
}

@description('Resource ID of the virtual network.')
output vnetId string = vnet.id

@description('Name of the virtual network.')
output vnetName string = vnet.name

@description('Map of subnet name to subnet resource ID.')
output subnetIds object = toObject(vnet.properties.subnets, s => s.name, s => s.id)

metadata name = 'Network Security Group'
metadata description = 'Deploys a Network Security Group with configurable security rules.'
metadata owner = 'rioarijit-labs'

@description('Name of the network security group.')
param name string

@description('Azure region for the network security group.')
param location string = resourceGroup().location

@description('Security rules to apply. See Microsoft.Network/networkSecurityGroups/securityRules schema for the shape of each item.')
param securityRules array = []

@description('Resource tags to apply.')
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

@description('Resource ID of the network security group.')
output nsgId string = nsg.id

@description('Name of the network security group.')
output nsgName string = nsg.name

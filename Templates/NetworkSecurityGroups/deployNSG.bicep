/*
Description: This script deploys an NSG with RDP inbound allowed.
CreatedBy: MawandaH@inobits.com
CreationDate: 05/03/2022
Github repo: https://github.com/blaqvikin/Bicep-In-The-Making*/

@description('Get the location for the resources to be dpeloyed in')
param location string = resourceGroup().location

@description('Define the rules to update the NSG with')
param securityRuleName string = 'bicep_NSG1'

resource NSGname 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: securityRuleName
  location: location
  properties: {
    flushConnection: false
    securityRules: [
      {
        id: '1'
        name: 'MH-Allow-RDP'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          description: 'Allow RDP in From MH'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          priority: '2000'
        }
      }
    ]
  }
  tags: {
    Product: 'Network Security Groups'
    IAC: 'Bicep'
    CreatedBy: 'MawandaH'
  }
  
}
@description('The network security group that has been deployed')
output NSG string = NSGname.name

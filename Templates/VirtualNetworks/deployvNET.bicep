/*
Description: This script deploys a single vNET with multiple subnets
CreatedBy: MawandaH@inobits.com
CreationDate: 05/03/2022
Github repo: https://github.com/blaqvikin/Bicep-In-The-Making*/

@description('Get the location for the resources to be dpeloyed in')
param location string = resourceGroup().location

/*resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: 'Existing resource group'
  scope: resourceGroup(exampleRG)
}*/
@description('Define the virtual network name')
param vNETname string = 'bicepVNET4'

@description('Define the vNET address space, this could look like this 10.0.0.0/16')
param addressSpace string = '172.21.0.0/16'

@description('Define the subnet/s to be created during deployment of this vNET, this could look like this 0.0.0.0/24')
param subnetRanges array = [
'subnet1'
'subnet2'
'subnet3'
]

//Define a loop to iterate to all the ranges defined for your subnets
var subnetProperties = [for (subnetName, i) in subnetRanges: {
  name: subnetName
  properties: {
    addressPrefix: '172.21.${i}.0/24'
  }
}]
//Deploy the virtual network resource
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01'= {
  name: vNETname
  location: location
properties: {
  addressSpace: {
    addressPrefixes: [
      addressSpace
    ]
  }
  // Apply the loop that deploys each subnet
  subnets: subnetProperties
}
tags: {
  Product: 'Virtual Networks'
  IAC: 'Bicep'
  CreatedBy: 'MawandaH'
}
}
@description('The virtual network that was deployed')
output vNET string = virtualNetwork.name

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
param vNETname string = '<enter vNET name>'

@description('Define the vNET address space, this could look like this 10.0.0.0/16')
param addressSpace string = '172.20.0.0/16'

@description('Define the subnet/s to be created during deployment of this vNET, this could look like this 0.0.0.0/24')
param subnetRanges array = [
  {
  name:'subnet1'
      ipAddressRange: '172.20.1.0/24'
}
{
  name: 'subnet2'
      ipAddressRange: '172.20.2.0/24'
}
]

//Define a loop to iterate to all the ranges defined for your subnets
var subnetProperties = [for subnet in subnetRanges: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01'= {
  name: vNETname
  location: location
properties: {
  addressSpace: {
    addressPrefixes: [
      addressSpace
    ]
  }
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

@description('Get the location for the resources to be dpeloyed in')
param location string = resourceGroup().location

/*resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: 'Existing resource group'
  scope: subscription()
}*/
@description('Define the virtual network name')
param vNETname string = '<enter vNET name>'

@description('Define the vNET address space, this could look like this 10.0.0.0/16')
param addressPrefixes array

@description('Define the subnet/s to be created during deployment of this vNET, this could look like this 10.0.1.0/24')
param addressPrefix array

@description('Define the subnet name')
param subnetName string = '<subnetName>'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01'= {
  name: vNETname
  location: location
properties: {
  addressSpace: {
    addressPrefixes: [
      addressPrefixes
    ]
  }
  subnets: [
    {
      name: subnetName
      properties: {
        addressPrefix: addressPrefix
      }
    }
  ]
}
tags: {
  Product: 'Virtual Networks'
  IAC: 'Bicep'
}
}
@description('The virtual network that was deployed')
output vNET string = virtualNetwork.name

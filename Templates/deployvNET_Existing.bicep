/*
Description: This script updates a single vNET with multiple/single subnets
CreatedBy: MawandaH@inobits.com
CreationDate: 05/03/2022
Github repo: https://github.com/blaqvikin/Bicep-In-The-Making*/

@description('Get the location for the resources to be dpeloyed in')
param location string = resourceGroup().location

@description('Define the subnet/s to be created during deployment of this vNET, this could look like this 0.0.0.0/24')
param subnetRanges array = [
{
  name: 'subnet3'
      ipAddressRange: '172.20.3.0/24'
}
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: 'vNET2'
}

@batchSize(1)
resource subnetProperties 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = [for (subnet, index) in subnetRanges: {
  name: subnet.name
  parent: virtualNetwork
  //scope : resourceGroup(foreignRG) // when deploying to another resource group
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
  
}]
@description('The virtual network that was deployed')
output vNET string = virtualNetwork.name
output subnets array = virtualNetwork.properties.subnets

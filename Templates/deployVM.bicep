//Deploy a VM in Azure

@description('Location of the resource.')
param location string = resourceGroup().location

@description('The administrator account for the VM.')
@secure()
param vmAdministratorLogin string

@description('The administrator password for this VM.')
@secure()
param vmAdministratorPassword string

@description('The VM type deployed.')
@allowed([
  'DC'
  'Member'
  'SQL'
])
param vmRole string

@description('The environment being deployed to.')
@allowed([
  'Prod'
  'Dev'
])
param environmentName string

@description('The name of the virtual machine name.')
param vmName string = 'SpartanZA-${environmentName}${vmRole}' //create the vmName using the environmentName + vmRole

var vmSize = 'DS1_v2'

//Create the VM along with the properties and features.
resource virtulMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  tags: {
    CreatedBy: 'Inobits'
    Project: 'Azure Implementation'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: '/subscriptions/9c01462e-3ecc-402c-8f2f-116606b4fc42/resourceGroups/SCFResourceGroup/providers/Microsoft.Storage/storageAccounts/scfstorage/blobServices/default'
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v2'
      vmSizeProperties: {
        vCPUsAvailable: 2
        vCPUsPerCore: 2
      }
    }
    licenseType: 'Windows_Server'
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [
        {
          name: 'nic-${vmName}'
          properties:{
            deleteOption: 'Delete'
            dnsSettings:{
              dnsServers: null              
            }
            enableAcceleratedNetworking: true
            ipConfigurations: [
              {
                name: 'ipconfig${vmName}'
              }
            ]
          }
        }
      ]
    }
  }
}


//resource virtualMachine

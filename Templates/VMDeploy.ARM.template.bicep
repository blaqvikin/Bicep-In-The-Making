param location string
param networkInterfaceName string
param enableAcceleratedNetworking bool
param networkSecurityGroupName string
param networkSecurityGroupRules array
param subnetName string
param virtualNetworkId string
param virtualMachineName string
param virtualMachineComputerName string
param virtualMachineRG string
param osDiskType string
param osDiskDeleteOption string
param virtualMachineSize string
param nicDeleteOption string
param adminUsername string

@secure()
param adminPassword string
param patchMode string
param enableHotpatching bool
param diagnosticsStorageAccountName string
param diagnosticsStorageAccountId string

var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var vnetId = virtualNetworkId
var vnetName = last(split(vnetId, '/'))
var subnetRef = '${vnetId}/subnets/${subnetName}'

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: 'myKeyVault'
}

resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
    networkSecurityGroup: {
      id: nsgId
    }
  }
  tags: {
    CreatedBy: 'Inobits'
    Project: 'Azure Implementation'
    'Business Unit': 'IT'
  }
  dependsOn: [
    networkSecurityGroupName_resource
  ]
}

resource networkSecurityGroupName_resource 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
  tags: {
    CreatedBy: 'Inobits'
    Project: 'Azure Implementation'
    'Business Unit': 'IT'
  }
}

resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: osDiskDeleteOption
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceName_resource.id
          properties: {
            deleteOption: nicDeleteOption
          }
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: enableHotpatching
          patchMode: patchMode
        }
      }
    }
    licenseType: 'Windows_Server'
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${diagnosticsStorageAccountName}.blob.core.windows.net/'
      }
    }
  }
  tags: {
    CreatedBy: 'Inobits'
    Project: 'Azure Implementation'
    'Business Unit': 'IT'
  }
}

output adminUsername string = adminUsername

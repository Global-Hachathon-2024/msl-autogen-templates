@description('The name of the resource group')
param resourceGroupName string

@description('The location of the resource group')
param location string = 'westus3'

@description('The name of the virtual machine')
param vmName string = 'myVM'

@description('The admin username for the virtual machine')
param adminUsername string = 'azureuser'

@description('The admin password for the virtual machine')
param adminPassword string

resource vmPublicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}-publicIp'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vmVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${vmName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vmVnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vmPublicIp.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic.id
        }
      ]
    }
  }
}

resource openPort80 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${vmName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-http'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
    ]
  }
}

resource nsgAssociation 'Microsoft.Network/networkInterfaces/networkSecurityGroup@2021-02-01' = {
  parent: vmNic
  properties: {
    networkSecurityGroup: {
      id: openPort80.id
    }
  }
}

resource installIIS 'Microsoft.Compute/virtualMachines/runCommands@2021-07-01' = {
  name: 'InstallIIS'
  parent: vm
  properties: {
    asyncExecution: false
    source: {
      script: 'Install-WindowsFeature -name Web-Server -IncludeManagementTools'
    }
  }
}

output publicIpAddress string = vmPublicIp.properties.ipAddress
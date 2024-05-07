@description('Naming prefix for all deployed resources')
param prefix string

@description('Resource group location/region')
param RGlocation string = resourceGroup().location

@description('Naming prefix for all on-premise resources')
param vpnsitePrefix string

@description('Name of the Virtual Wan.')
param vWanName string = ''

@description('Name of the Virtual Hub. A virtual hub is created inside a virtual wan.')
param hubName string = ''

@description('The hub address prefix. This address prefix will be used as the address prefix for the hub vnet')
param hubAddressPrefix string = '172.16.160.0/24'

@description('Name of the Vpn Gateway. A vpn gateway is created inside a virtual hub.')
param vpnGatewayName string = ''

@description('The bgp asn number of the hub.')
param vpnGwBgpAsn int = 65515

@description('Name of the vpnsite. A vpnsite represents the on-premise vpn device. A public ip address is mandatory for a vpn site creation.')
param vpnsiteName string = ''

@description('Name of the vpnconnection. A vpn connection is established between a vpnsite and a vpn gateway.')
param connectionName string = ''

@description('A list of static routes corresponding to the vpn site. These are configured on the vpn gateway.')
param vpnsiteAddressspaceList array = []

@description('The public IP address of a vpn site.')
param vpnsitePublicIPAddress string

@description('The bgp asn number of a vpnsite.')
param vpnsiteBgpAsn int = 65010

@description('The bgp peer IP address of a vpnsite.')
param vpnsiteBgpPeeringAddress string = '169.254.111.1'

param adminUsername string

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

param fortiGateImageSKU string = 'fortinet_fg-vm_payg_2023'

@description('Select the image version')
@allowed([
  '7.0.14'
  '7.2.8'
  '7.4.3'
  'latest'
])
param fortiGateImageVersion string = 'latest'

@description('Virtual Machine size selection - must be F4 or other instance that supports 4 NICs')
@allowed([
  'Standard_F4s'
  'Standard_F4'
  'Standard_F4s_v2'
  'Standard_DS3_v2'
  'Standard_D4s_v3'
  'Standard_D4_v4'
  'Standard_D4s_v4'
  'Standard_D4a_v4'
  'Standard_D4as_v4'
  'Standard_D4_v5'
 
])
param instanceType string = 'Standard_F4'

@description('Whether to use a public IP and if so whether it is new')
@allowed([
  'new'
  'existing'
])
param publicIP2NewOrExisting string = 'new'

@description('Whether to use a public IP and if so whether it is new')
@allowed([
  'new'
  'existing'
])
param publicIP3NewOrExisting string = 'new'

@description('Name of Public IP address element.')
param publicIP2Name string = ''

@description('Resource group to which the Public IP belongs.')
param publicIP2ResourceGroup string = ''

@description('Name of Public IP address element.')
param publicIP3Name string = ''

@description('Resource group to which the Public IP belongs.')
param publicIP3ResourceGroup string = ''

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network.')
param vnetName string = ''

@description('Resource Group containing the virtual network - or new resource group from above (if new vnet)')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '172.16.136.0/22'

@description('Subnet 1 Name')
param subnet1Name string = 'ExternalSubnet'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '172.16.136.0/26'

@description('Subnet 2 Name')
param subnet2Name string = 'InternalSubnet'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '172.16.136.64/26'

@description('Subnet 3 Name')
param subnet3Name string = 'HASyncSubnet'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '172.16.136.128/26'

@description('Subnet 4 Name')
param subnet4Name string = 'ManagementSubnet'

@description('Subnet 4 Prefix')
param subnet4Prefix string = '172.16.136.192/26'

@description('Protected A Subnet 5 Name')
param subnet5Name string = 'ProtectedASubnet'

@description('Protected A Subnet 5 Prefix')
param subnet5Prefix string = '172.16.137.0/24'



var lab2var = 'Delete or comment this line'
var vWanNamevar = ((vWanName == '') ? '${prefix}-VWAN-${RGlocation}' : vWanName)
var hubNamevar = ((hubName == '') ? '${prefix}-HUB-${RGlocation}' : hubName)
var vpnGatewayNamevar = ((vpnGatewayName == '') ? '${prefix}-VPNGW' : hubName)
var vpnsiteNamevar = ((vpnsiteName == '') ? '${prefix}-${vpnsitePrefix}-VPN' : vpnsiteName)
var connectionNamevar = ((connectionName == '') ? '${prefix}-${vpnsitePrefix}-VPN-CONNECTION' : connectionName)
var vnetNamevar = ((vnetName == '') ? '${prefix}-VNET' : vnetName)
var sn2IPArray = split(subnet2Prefix, '.')
var sn2IPArray2ndString = string(sn2IPArray[3])
var sn2IPArray2nd = split(sn2IPArray2ndString, '/')
var sn2IPArray2 = string(int(sn2IPArray[2]))
var sn2IPArray1 = string(int(sn2IPArray[1]))
var sn2IPArray0 = string(int(sn2IPArray[0]))
var sn2IPlb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPArray2nd[0])+4)}'

resource vWan 'Microsoft.Network/virtualWans@2023-04-01' = {
  name: vWanNamevar
  location: RGlocation
  properties: {}
}

resource hub 'Microsoft.Network/virtualHubs@2023-04-01' = {
  name: hubNamevar
  location: RGlocation
  properties: {
    addressPrefix: hubAddressPrefix
    virtualWan: {
      id: vWan.id
    }
  }
}

resource vpnsite 'Microsoft.Network/vpnSites@2023-04-01' = {
  name: vpnsiteNamevar
  location: RGlocation
  properties: {
    addressSpace: {
      addressPrefixes: vpnsiteAddressspaceList
    }
    bgpProperties: {
      asn: vpnsiteBgpAsn
      bgpPeeringAddress: vpnsiteBgpPeeringAddress
      peerWeight: 0
    }
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    ipAddress: vpnsitePublicIPAddress
    virtualWan: {
      id: vWan.id
    }
  }
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2023-04-01' = {
  name: vpnGatewayNamevar
  location: RGlocation
  properties: {
    connections: [
      {
        name: connectionNamevar
        properties: {
          connectionBandwidth: 10
          enableBgp: true
          remoteVpnSite: {
            id: vpnsite.id
          }
        }
      }
    ]
    virtualHub: {
      id: hub.id
    }
    bgpSettings: {
      asn: vpnGwBgpAsn
    }
  }
}



@description('Deploy FortiGate VMs in an Availability Set or Availability Zones. If Availability Zones deployment is selected but the location does not support Availability Zones an Availability Set will be deployed. If Availability Zones deployment is selected and Availability Zones are available in the location, FortiGate A will be placed in Zone 1, FortiGate B will be placed in Zone 2')
@allowed([
  'Availability Set'
  'Availability Zones'
])
param availabilityOptions string = 'Availability Set'



@description('Public IP for the Load Balancer for inbound and outbound data of the FortiGate VMs')
@allowed([
  'new'
  'existing'
])
param publicIP1NewOrExisting string = 'new'

@description('Name of Public IP address, if no name is provided the default name will be the Resource Group Name as the Prefix and \'-FGT-PIP\' as the suffix')
param publicIP1Name string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIP1ResourceGroup string = ''


param subnet1StartAddress string = '172.16.136.4'


@description('Subnet 2 start address, 3 consecutive private IPs are required')
param subnet2StartAddress string = '172.16.136.68'


@description('Subnet 3 start address, 2 consecutive private IPs are required')
param subnet3StartAddress string = '172.16.136.132'


@description('Subnet 4 start address, 2 consecutive private IPs are required')
param subnet4StartAddress string = '172.16.136.196'


@description('Enable Serial Console')
@allowed([
  'yes'
  'no'
])
param serialConsole string = 'yes'

@description('Location for all resources.')
param location string = resourceGroup().location
param fortinetTags object = {
  publisher: 'Fortinet'
  template: 'Active-Passive-ELB-ILB'
  provider: '6EB3B02F-50E5-4A3E-8CB8-2E12925831AP'
}

var imagePublisher = 'fortinet'
var imageOffer = 'fortinet_fortigate-vm_v5'
var availabilitySetName = '${prefix}-AvailabilitySet'
var availabilitySetId = {
  id: availabilitySet.id
}

var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name))
var subnet3Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name))
var subnet4Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name))
var fgaVmName = '${prefix}-FGT-A'
var fgbVmName = '${prefix}-FGT-B'
var routeTableName = '${prefix}-RouteTable-${subnet5Name}'
var routeTableId = routeTable.id
var fgaNic1Name = '${fgaVmName}-Nic1'
var fgaNic1Id = fgaNic1.id
var fgbNic1Name = '${fgbVmName}-Nic1'
var fgbNic1Id = fgbNic1.id
var fgaNic2Name = '${fgaVmName}-Nic2'
var fgaNic2Id = fgaNic2.id
var fgbNic2Name = '${fgbVmName}-Nic2'
var fgbNic2Id = fgbNic2.id
var fgaNic3Name = '${fgaVmName}-Nic3'
var fgaNic3Id = fgaNic3.id
var fgbNic3Name = '${fgbVmName}-Nic3'
var fgbNic3Id = fgbNic3.id
var fgaNic4Name = '${fgaVmName}-Nic4'
var fgaNic4Id = fgaNic4.id
var fgbNic4Name = '${fgbVmName}-Nic4'
var fgbNic4Id = fgbNic4.id
var serialConsoleStorageAccountNamevar = 'console${uniqueString(resourceGroup().id)}'
var serialConsoleStorageAccountType = 'Standard_LRS'
var serialConsoleEnabled = ((serialConsole == 'yes') ? true : false)
var publicIP1Namevar = ((publicIP1Name == '') ? '${prefix}-FGT-PIP' : publicIP1Name)
var publicIP1Id = ((publicIP1NewOrExisting == 'new') ? publicIP1.id : resourceId(publicIP1ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP1Namevar))
var publicIP2Namevar = ((publicIP2Name == '') ? '${prefix}-FGT-A-MGMT-PIP' : publicIP2Name)
var publicIP2Id = ((publicIP2NewOrExisting == 'new') ? publicIP2Name_resource.id : resourceId(publicIP2ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP2Namevar))
var publicIPAddress2Id = {
  id: publicIP2Id
}
var publicIP3Namevar = ((publicIP3Name == '') ? '${prefix}-FGT-B-MGMT-PIP' : publicIP3Name)
var publicIP3Id = ((publicIP3NewOrExisting == 'new') ? publicIP3Name_resource.id : resourceId(publicIP3ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP3Namevar))
var publicIPAddress3Id = {
  id: publicIP3Id
}
var NSGNamevar = '${prefix}-${uniqueString(resourceGroup().id)}-NSG'
var NSGId = NSGName.id
var sn1IPArray = split(subnet1Prefix, '.')
var sn1IPArray2 = string(int(sn1IPArray[2]))
var sn1IPArray1 = string(int(sn1IPArray[1]))
var sn1IPArray0 = string(int(sn1IPArray[0]))
var sn1IPStartAddress = split(subnet1StartAddress, '.')
var sn1IPfga = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${int(sn1IPStartAddress[3])}'
var sn1IPfgb = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${(int(sn1IPStartAddress[3]) + 1)}'
var sn2IPStartAddress = split(subnet2StartAddress, '.')
var sn2IPfga = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 1)}'
var sn2IPfgb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 2)}'
var sn3IPArray = split(subnet3Prefix, '.')
var sn3IPArray2 = string(int(sn3IPArray[2]))
var sn3IPArray1 = string(int(sn3IPArray[1]))
var sn3IPArray0 = string(int(sn3IPArray[0]))
var sn3IPStartAddress = split(subnet3StartAddress, '.')
var sn3IPfga = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${int(sn3IPStartAddress[3])}'
var sn3IPfgb = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${(int(sn3IPStartAddress[3]) + 1)}'
var sn4IPArray = split(subnet4Prefix, '.')
var sn4IPArray2 = string(int(sn4IPArray[2]))
var sn4IPArray1 = string(int(sn4IPArray[1]))
var sn4IPArray0 = string(int(sn4IPArray[0]))
var sn4IPStartAddress = split(subnet4StartAddress, '.')
var sn4IPfga = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${int(sn4IPStartAddress[3])}'
var sn4IPfgb = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${(int(sn4IPStartAddress[3]) + 1)}'
var internalLBNamevar = '${prefix}-InternalLoadBalancer'
var internalLBFEName = '${prefix}-ILB-${subnet2Name}-FrontEnd'
var internalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', internalLBNamevar, internalLBFEName)
var internalLBBEName = '${prefix}-ILB-${subnet2Name}-BackEnd'
var internalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools/', internalLBNamevar, internalLBBEName)
var internalLBProbeName = 'lbprobe'
var internalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes/', internalLBNamevar, internalLBProbeName)
var externalLBNamevar = '${prefix}-ExternalLoadBalancer'
var externalLBFEName = '${prefix}-ELB-${subnet1Name}-FrontEnd'
var externalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', externalLBNamevar, externalLBFEName)
var externalLBBEName = '${prefix}-ELB-${subnet1Name}-BackEnd'
var externalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools/', externalLBNamevar, externalLBBEName)
var externalLBProbeName = 'lbprobe'
var externalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes/', externalLBNamevar, externalLBProbeName)
var useAZ = ((!empty(pickZones('Microsoft.Compute', 'virtualMachines', location))) && (availabilityOptions == 'Availability Zones'))
var zone1 = [
  '1'
]
var zone2 = [
  '2'
]

resource serialConsoleStorageAccountName 'Microsoft.Storage/storageAccounts@2023-01-01' = if (serialConsole == 'yes') {
  name: serialConsoleStorageAccountNamevar
  location: location
  kind: 'Storage'
  sku: {
    name: serialConsoleStorageAccountType
  }
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2023-09-01' = if (!useAZ) {
  name: availabilitySetName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 2
  }
  sku: {
    name: 'Aligned'
  }
}

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: routeTableName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'toDefault'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2023-04-01' = if (vnetNewOrExisting == 'new') {
  name: vnetNamevar
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4Prefix
        }
      }
      {
        name: subnet5Name
        properties: {
          addressPrefix: subnet5Prefix
          routeTable: {
            id: routeTableId
          }
        }
      }
    ]
  }
}

resource internalLBName 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: internalLBNamevar
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: internalLBFEName
        properties: {
          privateIPAddress: sn2IPlb
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet2Id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: internalLBBEName
      }
    ]
    loadBalancingRules: [
      {
        properties: {
          frontendIPConfiguration: {
            id: internalLBFEId
          }
          backendAddressPool: {
            id: internalLBBEId
          }
          probe: {
            id: internalLBProbeId
          }
          protocol: 'All'
          frontendPort: 0
          backendPort: 0
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'lbruleFE2all'
      }
    ]
    probes: [
      {
        properties: {
          protocol: 'Tcp'
          port: 8008
          intervalInSeconds: 5
          numberOfProbes: 2
        }
        name: internalLBProbeName
      }
    ]
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource NSGName 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: NSGNamevar
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAllInbound'
        properties: {
          description: 'Allow all in'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          description: 'Allow all out'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource publicIP1 'Microsoft.Network/publicIPAddresses@2023-04-01' = if (publicIP1NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP1Namevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: '${toLower(prefix)}-${uniqueString(resourceGroup().id)}'
    }
  }
}

resource publicIP2Name_resource 'Microsoft.Network/publicIPAddresses@2023-04-01' = if (publicIP2NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP2Namevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource publicIP3Name_resource 'Microsoft.Network/publicIPAddresses@2023-04-01' = if (publicIP3NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP3Namevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource externalLBName 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: externalLBNamevar
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: externalLBFEName
        properties: {
          publicIPAddress: {
            id: publicIP1Id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: externalLBBEName
      }
    ]
    loadBalancingRules: [
      {
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          backendAddressPool: {
            id: externalLBBEId
          }
          probe: {
            id: externalLBProbeId
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'PublicLBRule-FE1-http'
      }
      {
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          backendAddressPool: {
            id: externalLBBEId
          }
          probe: {
            id: externalLBProbeId
          }
          protocol: 'Udp'
          frontendPort: 10551
          backendPort: 10551
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'PublicLBRule-FE1-udp10551'
      }
    ]
    probes: [
      {
        properties: {
          protocol: 'Tcp'
          port: 8008
          intervalInSeconds: 5
          numberOfProbes: 2
        }
        name: externalLBProbeName
      }
    ]
  }
}

resource fgaNic1 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn1IPfga
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet1Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: externalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    externalLBName
  ]
}

resource fgbNic1 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn1IPfgb
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet1Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: externalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    externalLBName
  ]
}

resource fgaNic2 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn2IPfga
          subnet: {
            id: subnet2Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: internalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    internalLBName
  ]
}

resource fgbNic2 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn2IPfgb
          subnet: {
            id: subnet2Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: internalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    internalLBName
  ]
}

resource fgaNic3 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn3IPfga
          subnet: {
            id: subnet3Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgbNic3 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn3IPfgb
          subnet: {
            id: subnet3Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgaNic4 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic4Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfga
          publicIPAddress: (publicIP2NewOrExisting != 'none') ? publicIPAddress2Id : null
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgbNic4 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic4Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfgb
          publicIPAddress: (publicIP3NewOrExisting != 'none') ? publicIPAddress3Id : null
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgaVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: fgaVmName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: useAZ ? zone1 : null
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: (!useAZ) ? availabilitySetId : null
    osProfile: {
      computerName: fgaVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: fortiGateImageSKU
        version: fortiGateImageVersion
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 30
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: fgaNic1Id
        }
        {
          properties: {
            primary: false
          }
          id: fgaNic2Id
        }
        {
          properties: {
            primary: false
          }
          id: fgaNic3Id
        }
        {
          properties: {
            primary: false
          }
          id: fgaNic4Id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
        storageUri: (serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null
      }
    }
  }
}

resource fgbVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: fgbVmName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: useAZ ? zone2 : null
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: (!useAZ) ? availabilitySetId : null
    osProfile: {
      computerName: fgbVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: fortiGateImageSKU
        version: fortiGateImageVersion
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 30
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: fgbNic1Id
        }
        {
          properties: {
            primary: false
          }
          id: fgbNic2Id
        }
        {
          properties: {
            primary: false
          }
          id: fgbNic3Id
        }
        {
          properties: {
            primary: false
          }
          id: fgbNic4Id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
        storageUri: (serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null
      }
    }
  }
}

output fortiGatePublicIP string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).ipAddress : '')
output fortiGateFQDN string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).dnsSettings.fqdn : '')
output fortiGateAManagementPublicIP string = ((publicIP2NewOrExisting == 'new') ? reference(publicIP2Id).ipAddress : '')
output fortiGateBManagementPublicIP string = ((publicIP3NewOrExisting == 'new') ? reference(publicIP3Id).ipAddress : '')

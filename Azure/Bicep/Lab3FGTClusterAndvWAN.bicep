@description('Username for the Virtual Machine')
param FGTadminUsername string

@description('Password for the Virtual Machine')
@secure()
param FGTadminPassword string

@description('Naming prefix for all deployed resources. The FortiGate VMs will have the suffix \'-FGT-A\' and \'-FGT-B\'. For example if the prefix is \'ACME01\' the FortiGates will be named \'ACME01-FGT-A\' and \'ACME01-FGT-B\'')
param ResourcesPrefix string

@description('Identifies whether to to use PAYG (on demand licensing) or BYOL license model (where license is purchased separately)')
@allowed([
  'fortinet_fg-vm'
  'fortinet_fg-vm_payg_2023'
])
param fortiGateImageSKU string = 'fortinet_fg-vm_payg_2023'

@description('Select the FortiGate image version')
@allowed([
  '7.0.14'
  '7.2.8'
  '7.4.3'
  'latest'
])
param fortiGateImageVersion string = 'latest'

@description('The ARM template provides a basic configuration. Additional configuration can be added here.')
param fortiGateAdditionalCustomData string = ''

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

@description('Deploy FortiGate VMs in an Availability Set or Availability Zones. If Availability Zones deployment is selected but the location does not support Availability Zones an Availability Set will be deployed. If Availability Zones deployment is selected and Availability Zones are available in the location, FortiGate A will be placed in Zone 1, FortiGate B will be placed in Zone 2')
@allowed([
  'Availability Set'
  'Availability Zones'
])
param availabilityOptions string = 'Availability Set'

@description('Accelerated Networking enables direct connection between the VM and network card. Only available on 2 CPU F/Fs and 4 CPU D/Dsv2, D/Dsv3, E/Esv3, Fsv2, Lsv2, Ms/Mms and Ms/Mmsv2')
@allowed([
  true
  false
])
param acceleratedNetworking bool = true

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

@description('Public IP for management of the FortiGate A. This deployment uses a Standard SKU Azure Load Balancer and requires a Standard SKU public IP. Microsoft Azure offers a migration path from a basic to standard SKU public IP. The management IP\'s for both FortiGate can be set to none. If no alternative internet access is provided, the SDN Connector functionality for dynamic objects will not work.')
@allowed([
  'new'
  'existing'
  'none'
])
param publicIP2NewOrExisting string = 'new'

@description('Name of Public IP address, if no name is provided the default name will be the Resource Group Name as the Prefix and \'-FGT-A-MGMT-PIP\' as the suffix')
param publicIP2Name string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIP2ResourceGroup string = ''

@description('Public IP for management of the FortiGate B. This deployment uses a Standard SKU Azure Load Balancer and requires a Standard SKU public IP. Microsoft Azure offers a migration path from a basic to standard SKU public IP. The management IP\'s for both FortiGate can be set to none. If no alternative internet access is provided, the SDN Connector functionality for both HA failover and dynamic objects will not work.')
@allowed([
  'new'
  'existing'
  'none'
])
param publicIP3NewOrExisting string = 'new'

@description('Name of Public IP address, if no name is provided the default name will be the Resource Group Name as the Prefix and \'-FGT-B-MGMT-PIP\' as the suffix')
param publicIP3Name string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIP3ResourceGroup string = ''

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network, required if utilizing an existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnetName string = ''
@description('Name of the Azure virtual network, required if utilizing an existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnet2Name string = ''
@description('Resource Group containing the existing virtual network, leave blank if a new VNET is being utilized')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '172.16.0.0/16'
@description('Virtual Network Address prefix')
param vnet2AddressPrefix string = '10.0.0.0/16'
@description('Subnet 1 Name')
param subnet1Name string = 'ExternalSubnet'
@description('VNET2 Subnet 1 Name')
param VNET2Subnet1Name string = 'VNET2Subnet1'
@description('Subnet 1 Prefix')
param subnet1Prefix string = '172.16.1.0/26'

@description('Subnet 1 start address, 2 consecutive private IPs are required')
param subnet1StartAddress string = '172.16.1.4'

@description('Subnet 2 Name')
param subnet2Name string = 'InternalSubnet'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '172.16.2.0/24'

@description('Subnet 2 start address, 3 consecutive private IPs are required')
param subnet2StartAddress string = '172.16.2.4'

@description('Subnet 3 Name')
param subnet3Name string = 'HASyncSubnet'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '172.16.3.0/24'

@description('Subnet 3 start address, 2 consecutive private IPs are required')
param subnet3StartAddress string = '172.16.3.4'

@description('Subnet 4 Name')
param subnet4Name string = 'ManagementSubnet'

@description('Subnet 4 Prefix')
param subnet4Prefix string = '172.16.4.0/24'

@description('VNET2 Subnet 1 Prefix')
param VNET2subnet1Prefix string = '10.0.1.0/24'

@description('Subnet 4 start address, 2 consecutive private IPs are required')
param subnet4StartAddress string = '172.16.4.4'

@description('Subnet 5 Name')
param subnet5Name string = 'ProtectedASubnet'

@description('Subnet 5 Prefix')
param subnet5Prefix string = '172.16.5.0/24'

@description('Enable Serial Console')
@allowed([
  'yes'
  'no'
])
param serialConsole string = 'yes'

@description('Connect to FortiManager')
@allowed([
  'yes'
  'no'
])
param fortiManager string = 'no'

@description('FortiManager IP or DNS name to connect to on port TCP/541')
param fortiManagerIP string = ''

@description('FortiManager serial number to add the deployed FortiGate into the FortiManager')
param fortiManagerSerial string = ''

@description('Primary FortiGate BYOL license content')
param fortiGateLicenseBYOLA string = '''-----BEGIN FGT VM LICENSE-----
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
c7b6yMxaQo2LAYYWZkXi7qMDYVvIHgXL
-----END FGT VM LICENSE-----
'''

@description('Secondary FortiGate BYOL license content')
param fortiGateLicenseBYOLB string = ''

@description('Primary FortiGate BYOL Flex-VM license token')
param fortiGateLicenseFlexVMA string = ''

@description('Secondary FortiGate BYOL Flex-VM license token')
param fortiGateLicenseFlexVMB string = ''


param fortinetTags object = {
  publisher: 'Fortinet'
  template: 'Active-Passive-ELB-ILB'
  provider: '6EB3B02F-50E5-4A3E-8CB8-2E12925831AP'
}

@description('Name of the Virtual Wan.')
param vWanName string = ''

@description('Name of the Virtual Hub. A virtual hub is created inside a virtual wan.')
param hubName string = ''


@description('The hub address prefix. This address prefix will be used as the address prefix for the hub vnet')
param hubAddressPrefix string = '172.17.100.0/24'

//Linux VM parameters section
@description('The name of your Virtual Machine.')
param LinuxVmNameVNET2 string = 'LAB3-LinuxVM-VNET2'

@description('The name of your Virtual Machine.')
param LinuxVmNameVNET1 string = 'LAB3-LinuxVM-VNET1'

@description('Username for the Virtual Machine.')
param LinuxUsername string

param authenticationType string = 'password'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param LinuxPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${LinuxVmNameVNET2}-${uniqueString(resourceGroup().id)}')



param ubuntuOSVersion string = 'Ubuntu-2204'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The size of the VM')
param LinuxVmSize string = 'Standard_B1ms'

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'LAB3-LinuxVM-SecGroupNet'

//vWAN and HUB Variables section

var vWanNamevar = ((vWanName == '') ? '${ResourcesPrefix}-VWAN-${location}' : vWanName)
var hubNamevar = ((hubName == '') ? '${ResourcesPrefix}-HUB-${location}' : hubName)
var vnetNamevar = ((vnetName == '') ? '${ResourcesPrefix}-VNET1' : vnetName)
var vnet2Namevar = ((vnet2Name == '') ? '${ResourcesPrefix}-VNET2' : vnet2Name)
var sn2IPArray2nd = split(sn2IPArray2ndString, '/')
var sn2IPArray2 = string(int(sn2IPArray[2]))
var sn2IPArray1 = string(int(sn2IPArray[1]))
var sn2IPArray0 = string(int(sn2IPArray[0]))
var sn2IPlb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPArray2nd[0])+4)}'

//Linux VMs variables section 
var imageReference = {
  
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}
var publicIPAddressName = '${LinuxVmNameVNET2}PublicIP'
var networkInterfaceName = '${LinuxVmNameVNET2}NetInt'

//var publicIPAddressNameLinux1 = '${LinuxVmNameVNET1}PublicIP'
var networkInterfaceNameLinux1 = '${LinuxVmNameVNET1}NetInt'

var osDiskType = 'Standard_LRS'
var linuxConfiguration = {
  disablePasswordAuthentication: false
  ssh: {
    publicKeys: [
      {
        path: '/home/${LinuxUsername}/.ssh/authorized_keys'
        keyData: LinuxPassword
      }
    ]
  }
}

//vWAN and HUB resources section
resource vWan 'Microsoft.Network/virtualWans@2023-04-01' = {
  name: vWanNamevar
  location: location
  properties: {}
}

resource hub 'Microsoft.Network/virtualHubs@2023-04-01' = {
  name: hubNamevar
  location: location
  properties: {
    addressPrefix: hubAddressPrefix
    virtualWan: {
      id: vWan.id
    }
  }
}

//FGT variables section
var imagePublisher = 'fortinet'
var imageOffer = 'fortinet_fortigate-vm_v5'
var availabilitySetNamevar = '${ResourcesPrefix}-AvailabilitySet'
var availabilitySetId = {
  id: availabilitySetName.id
}
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name))
var subnet3Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name))
var subnet4Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name))
var subnet5Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet5Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet5Name))

var VNET2subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnet2Namevar, VNET2Subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnet2Namevar, VNET2Subnet1Name))
var fgaVmNamevar = '${ResourcesPrefix}-FGT-A'
var fgbVmNamevar = '${ResourcesPrefix}-FGT-B'
var fmgCustomData = ((fortiManager == 'yes') ? '\nconfig system central-management\nset type fortimanager\n set fmg ${fortiManagerIP}\nset serial-number ${fortiManagerSerial}\nend\n config system interface\n edit port1\n append allowaccess fgfm\n end\n config system interface\n edit port2\n append allowaccess fgfm\n end\n' : '')
var customDataHeader = 'Content-Type: multipart/mixed; boundary="12345"\nMIME-Version: 1.0\n\n--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="config"\n\n'
var fgaCustomDataFlexVM = ((fortiGateLicenseFlexVMA == '') ? '' : 'exec vm-license ${fortiGateLicenseFlexVMA}\n')
var fgBCustomDataFlexVM = ((fortiGateLicenseFlexVMB == '') ? '' : 'exec vm-license ${fortiGateLicenseFlexVMB}\n')
var fgaCustomDataBody = 'config system sdn-connector\nedit AzureSDN\nset type azure\nnext\nend\nconfig router static\n edit 1\n set gateway ${sn1GatewayIP}\n set device port1\n next\n edit 2\n set dst ${vnetAddressPrefix}\n set gateway ${sn2GatewayIP}\n set device port2\n next\n edit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\n set gateway ${sn2GatewayIP}\n next\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\n set gateway ${sn1GatewayIP}\n next\n end\n config system probe-response\n set http-probe-value OK\n set mode http-probe\n end\n config system interface\n edit port1\n set mode static\n set ip ${sn1IPfga}/${sn1CIDRmask}\n set description external\n set allowaccess probe-response\n next\n edit port2\n set mode static\n set ip ${sn2IPfga}/${sn2CIDRmask}\n set description internal\n set allowaccess probe-response\n next\n edit port3\n set mode static\n set ip ${sn3IPfga}/${sn3CIDRmask}\n set description hasyncport\n next\n edit port4\n set mode static\n set ip ${sn4IPfga}/${sn4CIDRmask}\n set description management\n set allowaccess ping https ssh ftm\n next\n end\n config system ha\n set group-name AzureHA\n set mode a-p\n set hbdev port3 100\n set session-pickup enable\n set session-pickup-connectionless enable\n set ha-mgmt-status enable\n config ha-mgmt-interfaces\n edit 1\n set interface port4\n set gateway ${sn4GatewayIP}\n next\n end\n set override disable\n set priority 255\n set unicast-hb enable\n set unicast-hb-peerip ${sn3IPfgb}\n end\n${fmgCustomData}${fortiGateAdditionalCustomData}\n${fgaCustomDataFlexVM}\n'
var fgbCustomDataBody = 'config system sdn-connector\nedit AzureSDN\nset type azure\nnext\nend\nconfig router static\n edit 1\n set gateway ${sn1GatewayIP}\n set device port1\n next\n edit 2\n set dst ${vnetAddressPrefix}\n set gateway ${sn2GatewayIP}\n set device port2\n next\n edit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\n set gateway ${sn2GatewayIP}\n next\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\n set gateway ${sn1GatewayIP}\n next\n end\n config system probe-response\n set http-probe-value OK\n set mode http-probe\n end\n config system interface\n edit port1\n set mode static\n set ip ${sn1IPfgb}/${sn1CIDRmask}\n set description external\n set allowaccess probe-response\n next\n edit port2\n set mode static\n set ip ${sn2IPfgb}/${sn2CIDRmask}\n set description internal\n set allowaccess probe-response\n next\n edit port3\n set mode static\n set ip ${sn3IPfgb}/${sn3CIDRmask}\n set description hasyncport\n next\n edit port4\n set mode static\n set ip ${sn4IPfgb}/${sn4CIDRmask}\n set description management\n set allowaccess ping https ssh ftm\n next\n end\n config system ha\n set group-name AzureHA\n set mode a-p\n set hbdev port3 100\n set session-pickup enable\n set session-pickup-connectionless enable\n set ha-mgmt-status enable\n config ha-mgmt-interfaces\n edit 1\n set interface port4\n set gateway ${sn4GatewayIP}\n next\n end\n set override disable\n set priority 1\n set unicast-hb enable\n set unicast-hb-peerip ${sn3IPfga}\n end\n${fmgCustomData}${fortiGateAdditionalCustomData}\n${fgBCustomDataFlexVM}\n'
var customDataLicenseHeader = '--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="fgtlicense"\n\n'
var customDataFooter = '\n--12345--\n'
var fgaCustomDataCombined = '${customDataHeader}${fgaCustomDataBody}${customDataLicenseHeader}${fortiGateLicenseBYOLA}${customDataFooter}'
var fgbCustomDataCombined = '${customDataHeader}${fgbCustomDataBody}${customDataLicenseHeader}${fortiGateLicenseBYOLB}${customDataFooter}'
var fgaCustomData = base64(((fortiGateLicenseBYOLA == '') ? fgaCustomDataBody : fgaCustomDataCombined))
var fgbCustomData = base64(((fortiGateLicenseBYOLB == '') ? fgbCustomDataBody : fgbCustomDataCombined))
var routeTableNamevar = '${ResourcesPrefix}-RouteTable-${subnet5Name}'
var routeTableId = routeTableName.id
var fgaNic1Namevar = '${fgaVmNamevar}-Nic1'
var fgaNic1Id = fgaNic1Name.id
var fgbNic1Namevar = '${fgbVmNamevar}-Nic1'
var fgbNic1Id = fgbNic1Name.id
var fgaNic2Namevar = '${fgaVmNamevar}-Nic2'
var fgaNic2Id = fgaNic2Name.id
var fgbNic2Namevar = '${fgbVmNamevar}-Nic2'
var fgbNic2Id = fgbNic2Name.id
var fgaNic3Namevar = '${fgaVmNamevar}-Nic3'
var fgaNic3Id = fgaNic3Name.id
var fgbNic3Namevar = '${fgbVmNamevar}-Nic3'
var fgbNic3Id = fgbNic3Name.id
var fgaNic4Namevar = '${fgaVmNamevar}-Nic4'
var fgaNic4Id = fgaNic4Name.id
var fgbNic4Namevar = '${fgbVmNamevar}-Nic4'
var fgbNic4Id = fgbNic4Name.id
var serialConsoleStorageAccountNamevar = 'console${uniqueString(resourceGroup().id)}'
var serialConsoleStorageAccountType = 'Standard_LRS'
var serialConsoleEnabled = ((serialConsole == 'yes') ? true : false)
var publicIP1Namevar = ((publicIP1Name == '') ? '${ResourcesPrefix}-FGT-PIP' : publicIP1Name)
var publicIP1Id = ((publicIP1NewOrExisting == 'new') ? publicIP1Name_resource.id : resourceId(publicIP1ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP1Namevar))
var publicIP2Namevar = ((publicIP2Name == '') ? '${ResourcesPrefix}-FGT-A-MGMT-PIP' : publicIP2Name)
var publicIP2Id = ((publicIP2NewOrExisting == 'new') ? publicIP2Name_resource.id : resourceId(publicIP2ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP2Namevar))
var publicIPAddress2Id = {
  id: publicIP2Id
}
var publicIP3Namevar = ((publicIP3Name == '') ? '${ResourcesPrefix}-FGT-B-MGMT-PIP' : publicIP3Name)
var publicIP3Id = ((publicIP3NewOrExisting == 'new') ? publicIP3Name_resource.id : resourceId(publicIP3ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP3Namevar))
var publicIPAddress3Id = {
  id: publicIP3Id
}
var NSGNamevar = '${ResourcesPrefix}-${uniqueString(resourceGroup().id)}-NSG'
var NSGId = NSGName.id
var sn1IPArray = split(subnet1Prefix, '.')
var sn1IPArray2ndString = string(sn1IPArray[3])
var sn1IPArray2nd = split(sn1IPArray2ndString, '/')
var sn1CIDRmask = string(int(sn1IPArray2nd[1]))
var sn1IPArray3 = string((int(sn1IPArray2nd[0]) + 1))
var sn1IPArray2 = string(int(sn1IPArray[2]))
var sn1IPArray1 = string(int(sn1IPArray[1]))
var sn1IPArray0 = string(int(sn1IPArray[0]))
var sn1GatewayIP = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${sn1IPArray3}'
var sn1IPStartAddress = split(subnet1StartAddress, '.')
var sn1IPfga = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${int(sn1IPStartAddress[3])}'
var sn1IPfgb = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${(int(sn1IPStartAddress[3]) + 1)}'
var sn2IPArray = split(subnet2Prefix, '.')
var sn2IPArray2ndString = string(sn2IPArray[3])
var sn2CIDRmask = string(int(sn2IPArray2nd[1]))
var sn2IPArray3 = string((int(sn2IPArray2nd[0]) + 1))
var sn2GatewayIP = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${sn2IPArray3}'
var sn2IPStartAddress = split(subnet2StartAddress, '.')
var sn2IPfga = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 1)}'
var sn2IPfgb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 2)}'
var sn3IPArray = split(subnet3Prefix, '.')
var sn3IPArray2ndString = string(sn3IPArray[3])
var sn3IPArray2nd = split(sn3IPArray2ndString, '/')
var sn3CIDRmask = string(int(sn3IPArray2nd[1]))
var sn3IPArray2 = string(int(sn3IPArray[2]))
var sn3IPArray1 = string(int(sn3IPArray[1]))
var sn3IPArray0 = string(int(sn3IPArray[0]))
var sn3IPStartAddress = split(subnet3StartAddress, '.')
var sn3IPfga = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${int(sn3IPStartAddress[3])}'
var sn3IPfgb = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${(int(sn3IPStartAddress[3]) + 1)}'
var sn4IPArray = split(subnet4Prefix, '.')
var sn4IPArray2ndString = string(sn4IPArray[3])
var sn4IPArray2nd = split(sn4IPArray2ndString, '/')
var sn4CIDRmask = string(int(sn4IPArray2nd[1]))
var sn4IPArray3 = string((int(sn4IPArray2nd[0]) + 1))
var sn4IPArray2 = string(int(sn4IPArray[2]))
var sn4IPArray1 = string(int(sn4IPArray[1]))
var sn4IPArray0 = string(int(sn4IPArray[0]))
var sn4GatewayIP = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${sn4IPArray3}'
var sn4IPStartAddress = split(subnet4StartAddress, '.')
var sn4IPfga = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${int(sn4IPStartAddress[3])}'
var sn4IPfgb = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${(int(sn4IPStartAddress[3]) + 1)}'
var internalLBNamevar = '${ResourcesPrefix}-InternalLoadBalancer'
var internalLBFEName = '${ResourcesPrefix}-ILB-${subnet2Name}-FrontEnd'
var internalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', internalLBNamevar, internalLBFEName)
var internalLBBEName = '${ResourcesPrefix}-ILB-${subnet2Name}-BackEnd'
var internalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools/', internalLBNamevar, internalLBBEName)
var internalLBProbeName = 'lbprobe'
var internalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes/', internalLBNamevar, internalLBProbeName)
var externalLBNamevar = '${ResourcesPrefix}-ExternalLoadBalancer'
var externalLBFEName = '${ResourcesPrefix}-ELB-${subnet1Name}-FrontEnd'
var externalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', externalLBNamevar, externalLBFEName)
var externalLBBEName = '${ResourcesPrefix}-ELB-${subnet1Name}-BackEnd'
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

//Azure network resources section
resource availabilitySetName 'Microsoft.Compute/availabilitySets@2023-09-01' = if (!useAZ) {
  name: availabilitySetNamevar
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

resource routeTableName 'Microsoft.Network/routeTables@2023-04-01' = {
  name: routeTableNamevar
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

/*resource VNET2Subnet1routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'LAB3-VNET2Subnet1-RT'
  location: location
  properties: {
    routes: [
      {
        name: 'toDefault'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VnetLocal'
          
        }
      }
    ]
  }
}
*/
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

resource publicIP1Name_resource 'Microsoft.Network/publicIPAddresses@2023-04-01' = if (publicIP1NewOrExisting == 'new') {
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
      domainNameLabel: '${toLower(ResourcesPrefix)}-${uniqueString(resourceGroup().id)}'
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

//Linux VNET 2 resource section
resource LAB3VNET2 'Microsoft.Network/virtualNetworks@2023-04-01' = if (vnetNewOrExisting == 'new') {
  name: vnet2Namevar
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
            vnet2AddressPrefix
          ]
    }
    subnets: [
      {
        name: VNET2Subnet1Name
        properties: {
          addressPrefix: VNET2subnet1Prefix
          /*routeTable: {
            id: VNET2Subnet1routeTable.id
          }*/
        }
      }
    ]
  }
}

//FGT VMs resources section
resource fgaNic1Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic1Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    externalLBName
  ]
}

resource fgbNic1Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic1Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    externalLBName
  ]
}

resource fgaNic2Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic2Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    internalLBName
  ]
}

resource fgbNic2Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic2Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
    internalLBName
  ]
}

resource fgaNic3Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic3Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgbNic3Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic3Namevar
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgaNic4Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic4Namevar
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfga
          publicIPAddress: ((publicIP2NewOrExisting != 'none') ? publicIPAddress2Id : null)
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgbNic4Name 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic4Namevar
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfgb
          publicIPAddress: ((publicIP3NewOrExisting != 'none') ? publicIPAddress3Id : null)
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

resource fgaVmName 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: fgaVmNamevar
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: (useAZ ? zone1 : null)
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: ((!useAZ) ? availabilitySetId : null)
    osProfile: {
      computerName: fgaVmNamevar
      adminUsername: FGTadminUsername
      adminPassword: FGTadminPassword
      customData: fgaCustomData
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
        storageUri: ((serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null)
      }
    }
  }
}

resource fgbVmName 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: fgbVmNamevar
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: (useAZ ? zone2 : null)
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: ((!useAZ) ? availabilitySetId : null)
    osProfile: {
      computerName: fgbVmNamevar
      adminUsername: FGTadminUsername
      adminPassword: FGTadminPassword
      customData: fgbCustomData
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
        storageUri: ((serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null)
      }
    }
  }
}

//Linux VM VNET1 resources section
resource LinuxVNET1NetworkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: networkInterfaceNameLinux1
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { 
           id: subnet5Id
                     } 
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
  dependsOn: [
    vnetName_resource
  ]
}

//Linux VM VNET2 resources section
resource LinuxNetworkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { 
           id: VNET2subnet1Id
                     } 
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: LinuxVMpublicIPAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
  dependsOn: [
    LAB3VNET2
  ]
}




resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource LinuxVMpublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}


resource vm1 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: LinuxVmNameVNET1
  location: location
  properties: {
    hardwareProfile: {
      vmSize: LinuxVmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: imageReference[ubuntuOSVersion]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: LinuxVNET1NetworkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: LinuxVmNameVNET1
      adminUsername: LinuxUsername
      adminPassword: LinuxPassword
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
        storageUri: ((serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null)
      }
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: LinuxVmNameVNET2
  location: location
  properties: {
    hardwareProfile: {
      vmSize: LinuxVmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: imageReference[ubuntuOSVersion]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: LinuxNetworkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: LinuxVmNameVNET2
      adminUsername: LinuxUsername
      adminPassword: LinuxPassword
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
        storageUri: ((serialConsole == 'yes') ? reference(serialConsoleStorageAccountNamevar, '2021-08-01').primaryEndpoints.blob : null)
      }
    }
  }
}


//FGT VM output section
output fortiGatePublicIP string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).ipAddress : '')
output fortiGateFQDN string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).dnsSettings.fqdn : '')
output fortiGateAManagementPublicIP string = ((publicIP2NewOrExisting == 'new') ? reference(publicIP2Id).ipAddress : '')
output fortiGateBManagementPublicIP string = ((publicIP3NewOrExisting == 'new') ? reference(publicIP3Id).ipAddress : '')
//Linux VM output section
output adminUsername string = LinuxUsername
output hostname string = LinuxVMpublicIPAddress.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${LinuxUsername}@${LinuxVMpublicIPAddress.properties.dnsSettings.fqdn}'

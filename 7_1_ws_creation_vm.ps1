param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $VMName = 'webserver-01',
    $NIName = 'webserver-01-ni',
    $VNet = ''
)

# Create a virtual network card and associate it with public IP address and NSG
$NetworkInterface = New-AzNetworkInterface `
  -Name $NIName `
  -ResourceGroupName $RG `
  -Location $Location `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $pip.Id `
  -NetworkSecurityGroupId $nsg.Id

New-AzVm `
    -ResourceGroupName $RG `
    -Name $VMName `
    -Location $Location `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389


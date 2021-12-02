param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG'
)

Connect-AzAccount

#Create Application Security Groups
$WebAsg = New-AzApplicationSecurityGroup `
    -ResourceGroupName $RG `
    -Name "webservers-asg2" `
    -Location $Location

$SqlAsg = New-AzApplicationSecurityGroup `
    -ResourceGroupName $RG `
    -Name "sqlservers-asg2" `
    -Location $Location

#Define rules
$RDPRule = New-AzNetworkSecurityRuleConfig `
    -Name 'RDP' `
    -Description "Allow RDP" `
    -Access 'Allow' `
    -Protocol 'Tcp' `
    -Direction 'Inbound' `
    -Priority 111 `
    -SourceAddressPrefix 'VirtualNetwork' `
    -SourcePortRange * `
    -DestinationApplicationSecurityGroup @($WebAsg, $SqlAsg) `
    -DestinationPortRange 3389
$HTTPRule = New-AzNetworkSecurityRuleConfig `
    -Name 'HTTP' `
    -Description "Allow HTTP" `
    -Access 'Allow' `
    -Protocol 'Tcp' `
    -Direction 'Inbound' `
    -Priority 102 `
    -SourceAddressPrefix 'Internet' `
    -SourcePortRange * `
    -DestinationApplicationSecurityGroup $WebAsg `
    -DestinationPortRange 80
$HTTPSRule = New-AzNetworkSecurityRuleConfig `
    -Name 'HTTPS' `
    -Description "Allow HTTPS" `
    -Access 'Allow' `
    -Protocol 'Tcp' `
    -Direction 'Inbound' `
    -Priority 101 `
    -SourceAddressPrefix 'Internet' `
    -SourcePortRange * `
    -DestinationApplicationSecurityGroup $WebAsg `
    -DestinationPortRange 443
$MSSQLRule = New-AzNetworkSecurityRuleConfig `
    -Name 'MSSQL' `
    -Description "Allow MSSQL" `
    -Access 'Allow' `
    -Protocol 'Tcp' `
    -Direction 'Inbound' `
    -Priority 121 `
    -SourceAddressPrefix 'VirtualNetwork' `
    -SourcePortRange * `
    -DestinationApplicationSecurityGroup $SqlAsg `
    -DestinationPortRange 1433

#Create a network security group
$NSG = New-AzNetworkSecurityGroup `
    -Name "skillup-nsg2" `
    -ResourceGroupName $RG `
    -Location $Location `
    -SecurityRules $RDPRule, $HTTPRule, $HTTPSRule, $MSSQLRule

#Create virtual network
$vnet = New-AzVirtualNetwork `
    -Name "skillup-vnet2" `
    -ResourceGroupName $RG `
    -Location $Location `
    -AddressPrefix "192.22.0.0/22" `

#Create Subnets
$PrimarySubnet = Add-AzVirtualNetworkSubnetConfig `
    -Name "PrimarySubnet" `
    -AddressPrefix "192.22.0.0/23" `
    -NetworkSecurityGroup $NSG `
    -VirtualNetwork $vnet `

$WebappsSubnet = Add-AzVirtualNetworkSubnetConfig `
    -Name "WebappsSubnet" `
    -AddressPrefix "192.22.2.0/24" `
    -NetworkSecurityGroup $NSG `
    -VirtualNetwork $vnet `

$GatewaySubnet = Add-AzVirtualNetworkSubnetConfig `
    -Name "GatewaySubnet" `
    -AddressPrefix "192.22.3.0/24" `
    -VirtualNetwork $vnet `
    -NetworkSecurityGroup $NSG `

#Add subnets to the network
$PrimarySubnet | Set-AzVirtualNetwork 
$WebappsSubnet | Set-AzVirtualNetwork
$GatewaySubnet | Set-AzVirtualNetwork



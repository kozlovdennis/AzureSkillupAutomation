param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $VMName = 'webserver-01',
    $VMSize = 'Standard B1ms',
    $NIName = 'webserver-01-ni',
    $VNet = '',
    $VMUsername = 'winadmin',
    $VMUserPasswd = '',
    $Blah = ''
)



New-AzVm `
-ResourceGroupName $RG `
-Name $VMName `
-Location $Location `
-VirtualNetworkName "myVnet" `
-SubnetName "mySubnet" `
-SecurityGroupName "myNetworkSecurityGroup" `
-PublicIpAddressName "myPublicIpAddress" `
-OpenPorts 80,3389


# Create a public IP address and specify a DNS name
$PublicIP = New-AzPublicIpAddress `
  -ResourceGroupName $RG `
  -Location $Location `
  -AllocationMethod Static `
  -IdleTimeoutInMinutes 4 `
  -Name "mypublicdns$(Get-Random)"

#Create a virtual network card and associate it with public IP address and NSG
$NetworkInterface = New-AzNetworkInterface `
  -Name $NIName `
  -ResourceGroupName $RG `
  -Location $Location `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $PublicIP.Id `
  -NetworkSecurityGroupId $nsg.Id

#Creating a VM
# Define a credential object to store the username and password for the VM
$Password = $VMUserPasswd | ConvertTo-SecureString -Force -AsPlainText
$Credential = New-Object PSCredential($VMUserPasswd,$Password)

# Create the VM configuration object
$VmName = "VirtualMachinelatest"
$VmSize = "Standard_A1"
$VirtualMachine = New-AzVMConfig `
  -VMName $VmName `
  -VMSize $VmSize

$VirtualMachine = Set-AzVMOperatingSystem `
  -VM $VirtualMachine `
  -Windows `
  -ComputerName "MainComputer" `
  -Credential $Credential -ProvisionVMAgent

$VirtualMachine = Set-AzVMSourceImage `
  -VM $VirtualMachine `
  -PublisherName "MicrosoftWindowsServer" `
  -Offer "WindowsServer" `
  -Skus "2016-Datacenter" `
  -Version "latest"

# Sets the operating system disk properties on a VM.
$VirtualMachine = Set-AzVMOSDisk `
  -VM $VirtualMachine `
  -CreateOption FromImage | `
  Set-AzVMBootDiagnostic -ResourceGroupName $ResourceGroupName `
  -StorageAccountName $StorageAccountName -Enable |`
  Add-AzVMNetworkInterface -Id $nic.Id


# Create the VM.
New-AzVM `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -VM $VirtualMachine









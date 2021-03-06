#This script creates the WebServer Virtual Machine on Azure
#This script demands the '7_0_passwd_generator.ps1' script and the '7_0_update_keyvault.ps1' script to be in the same folder

param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $NSG = 'skillup-nsg',
    $VMName = 'webserver-01',
    $VMSize = 'Standard B1ms',
    $NICName = 'webserver-01-ni',
    $VNet = 'skillup-vnet',
    $Subnet = 'PrimarySubnet',
    $PublicIPName = 'webserver-01-pip',
    $VMUsername = 'winadmin',
    $Blah = ''
)

#Connecting to the Azure Account
Connect-AzAccount

#Find the path the script is located and assign to a variable
$ScriptPath = $MyInvocation.MyCommand.Path
#Linking the password generator script to a variable:
$PasswdGeneratorScript = $($(Split-Path $ScriptPath -Parent) + "\" + "7_0_passwd_generator.ps1")
#Linking the update keyvault script to a variable:
$UpdateKeyVaultScript = $($(Split-Path $ScriptPath -Parent) + "\" + "7_0_update_keyvault.ps1")

#Executing password generator script
. $PasswdGeneratorScript
#Getting the random password into the password variable
$Passwd = $(CreatePassword -Min 8 -Max 12)

#Executing update keyvault script:
. $UpdateKeyVaultScript
#Granting access to the keyvault
GrantAccess
#Passing the password value to update keyvault script fucntion:
UpdateKeyVault -Passwd $Passwd -PasswdName 'webserver-01-password'

<#
New-AzVm `
-ResourceGroupName $RG `
-Name $VMName `
-Location $Location `
-VirtualNetworkName $VNet `
-SubnetName "mySubnet" `
-SecurityGroupName "myNetworkSecurityGroup" `
-PublicIpAddressName "myPublicIpAddress" `
-OpenPorts 80,3389
#>



# Creating a public IP address
$PublicIP = @{
    Name = $PublicIPName
    ResourceGroupName = $RG
    Location = $Location
    Sku = 'Standard'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
}
New-AzPublicIpAddress @PublicIP

#Create a virtual network card and associate it with public IP address and NSG
$NetworkInterface = New-AzNetworkInterface `
    -Name $NICName `
    -ResourceGroupName $RG `
    -Location $Location `
    -SubnetId $Subnet.Id `
    -PublicIpAddressId $PublicIP.Id `
    -NetworkSecurityGroupId $NSG.Id

#Define a credential object to store the username and password for the VM
#Retrieve password from the keyvault
$VMUserPasswd = $(RetrievePassword) | ConvertTo-SecureString -Force -AsPlainText
$Credential = New-Object PSCredential($VMUsername,$VMUserPasswd)

#Create the VM configuration object
$VirtualMachine = New-AzVMConfig `
    -VMName $VMName `
    -VMSize $VMSize







<#
$VirtualMachine = Set-AzVMOperatingSystem `
  -VM $VirtualMachine `
  -Windows `
  -ComputerName "WS" `
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







#>

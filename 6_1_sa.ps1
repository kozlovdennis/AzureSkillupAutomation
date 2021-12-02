param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $ServiceSA = "sasrvsunmonster",
    $DiagnosticSA = "sadgsunmonster",
    $ContainerNames = "logs scipts files",
    $SAAccessKey = "ELWgMbaLRPomYJNSumPHJc0T0EU3SVxbqTwKVJ2npOb87wKyRKrl4UQklT0+8u5tKwtlXyS46Y/9fwmaiIg9yg=="
)

Connect-AzAccount

#Create Azure Storage Account for service purposes
New-AzStorageAccount `
    -ResourceGroupName $RG `
    -Name $ServiceSA `
    -Location $Location `
    -SkuName 'Standard_LRS' `
    -Kind 'StorageV2' `
    -AccessTier 'Hot'

#Create containers for SA of service purposes
$StorageContext = New-AzStorageContext -StorageAccountName $ServiceSA -StorageAccountKey $SAAccessKey
$ContainerNames.split() | New-AzStorageContainer -Permission Off -Context $StorageContext

#Create Azure Storage Account for diagnostic purposes
New-AzStorageAccount `
    -ResourceGroupName $RG `
    -Name $DiagnosticSA `
    -Location $Location `
    -SkuName 'Standard_LRS' `
    -Kind 'StorageV2' `
    -AccessTier 'Hot'
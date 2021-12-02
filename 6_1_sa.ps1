param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $ServiceSA = "sasrvdenkozlov2",
    $DiagnosticSA = "sadgdenkozlov2",
    $ContainerNames = "logs scipts files",
    $SAAccessKey = "baWgdW/npRayNSQTu303RwN6VdOK4jBPjtDUDDTPd76W6DefyamYIrcBJXlauO/A+heUTVtuZQZxk1TtDTtb2w=="
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
#This script generates SAS token
param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $ServiceSA = "sasrvsunmonster",
    $Container = "files",
    $Path2File = "C:\Users\kozlov.d\Downloads\ChromeStandaloneSetup64.exe"
)

Connect-AzAccount

$UploadStorage=Get-AzStorageAccount -ResourceGroupName $RG -Name $ServiceSA
$SAContext=$UploadStorage.Context

New-AzStorageAccountSASToken `
    -Service 'Blob','File','Table','Queue' `
    -ResourceType 'Service','Container','Object' `
    -Permission "racwdlup" `
    -Protocol 'HttpsOnly' `
    -Context $SAContext

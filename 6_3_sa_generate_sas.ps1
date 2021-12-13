#This script generates SAS token
<<<<<<< HEAD
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

=======
>>>>>>> 3e0f127cef5e242bbd4c1d9709c9043e71eb8196
New-AzStorageAccountSASToken `
    -Service 'Blob','File','Table','Queue' `
    -ResourceType 'Service','Container','Object' `
    -Permission "racwdlup" `
    -Protocol 'HttpsOnly' `
    -Context $SAContext





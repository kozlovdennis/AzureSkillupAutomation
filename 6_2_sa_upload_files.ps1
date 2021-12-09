param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $ServiceSA = "sasrvsunmonster",
    $Container = "files",
    $Path2File = "C:\Users\kozlov.d\Downloads\ChromeStandaloneSetup64.exe"
)

Connect-AzAccount

#Upload files to a container from the local folder
#Aquire a context
$UploadStorage = Get-AzStorageAccount -ResourceGroupName $RG -Name $ServiceSA
$SAContext = $UploadStorage.Context


#Upload a local file
Set-AzStorageBlobContent -Container $Container -File $Path2File -Context $SAContext

#Upload a local folder content
#Get-ChildItem -File -Recurse | Set-AzStorageBlobContent -Container "folder2" -Context $SAContext



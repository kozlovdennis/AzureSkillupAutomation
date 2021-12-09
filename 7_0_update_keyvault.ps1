#This script updates keyvault with a password created for VM
function UpdateKeyVault (){
    
    #Initializing parameters
    param (
        [Parameter(Position=0,mandatory=$true)]
        $Passwd,
        [Parameter(Position=1,mandatory=$true)]
        $PasswdName,

        $KeyVaultName = 'skillupkvsunmonster',
        $UserPrincipalName = 'admin@sunmonster.onmicrosoft.com',
        $Permissions = 'all'
    )
    
    #Setting the policiy to get access to keyvault
    Set-AzKeyVaultAccessPolicy `
        -VaultName $KeyVaultName `
        -UserPrincipalName $UserPrincipalName `
        -PermissionsToSecrets $Permissions

    #Converting the password to a secure string:
    $SecureString = ConvertTo-SecureString $Passwd -AsPlainText -Force

    #Setting the secure string to the keyvault
    Set-AzKeyVaultSecret `
        -VaultName $KeyVaultName `
        -Name $PasswdName `
        -SecretValue $SecureString

    #Getting the value from the keyvault
    $Secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $PasswdName -AsPlainText
    Write-Host "Your VM password: " -NoNewline
    Write-Host $Secret -ForegroundColor Yellow
}

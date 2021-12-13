#This script updates keyvault with a password created for VM
#Initializing parameters
param (

    [Parameter(Position=0,mandatory=$true)]
    $PasswdName,
    [Parameter(Position=1,mandatory=$true)]
    $Passwd,
    $Permissions = 'all',
    $KeyVaultName = 'skillupkvsunmonster',
    $UserPrincipalName = 'admin@sunmonster.onmicrosoft.com'
)

function GrantAccess (){

    #Setting the policiy to get access to keyvault
    Set-AzKeyVaultAccessPolicy `
        -VaultName $KeyVaultName `
        -UserPrincipalName $UserPrincipalName `
        -PermissionsToSecrets $Permissions
}

function UpdateKeyVault (){

    #Converting the password to a secure string:
    $SecureString = ConvertTo-SecureString $Passwd -AsPlainText -Force

    #Setting the secure string to the keyvault
    Set-AzKeyVaultSecret `
        -VaultName $KeyVaultName `
        -Name $PasswdName `
        -SecretValue $SecureString
}

function RetrievePassword (){

    #Getting the value from the keyvault
    $Secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $PasswdName -AsPlainText
    #Return the password as a plain text to the initiator
    $Secret
}
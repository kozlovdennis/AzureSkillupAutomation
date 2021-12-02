param (
    $Location = 'North Europe',
    $RG = 'SKILLUP-RG',
    $RetentionPeriod = 90,
    $SKU = "Standard",
    $RootUser = "koslovdennis@gmail.com",
    $AdminsGroup = "SG Admins",
    $PermsToKeys = "all",
    $PermsToSecrets = "all",
    $PermsToCerts = "all",
    $PermsToStorage = "all"
)

Connect-AzAccount

#Сreate keyvault
New-AzKeyVault `
    -Name "skillupkv2" `
    -ResourceGroupName $RG `
    -Location $Location `
    -SoftDeleteRetentionInDays $RetentionPeriod `
    -EnablePurgeProtection `
    -Sku "Standard" `

#Grant access policy permissions to a root user
Set-AzKeyVaultAccessPolicy `
    -VaultName "skillupkv2" `
    -UserPrincipalName $RootUser `
    -PermissionsToKeys $PermsToKeys `
    -PermissionsToSecrets $PermsToSecrets `
    -PermissionsToCertificates $PermsToCerts `
    -PermissionsToStorage $PermsToStorage `
    -PassThru
    
#Grant access policy permissions to "SG Admins" AD group
Set-AzKeyVaultAccessPolicy `
    -VaultName "skillupkv2" `
    -ObjectId (Get-AzADGroup -SearchString $AdminsGroup)[0].Id `
    -PermissionsToKeys $PermsToKeys `
    -PermissionsToSecrets $PermsToSecrets `
    -PermissionsToCertificates $PermsToCerts `
    -PermissionsToStorage $PermsToStorage `
    -PassThru


param (
    $Chars = "!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz",
    $Min = 8,
    $Max = 12
)

#Choosing the random characters number in this password:
$MaxNumber = Get-Random -Minimum $Min -Maximum $Max
#Showing the maximum number of characters (plus 1 character provided by zero)
Write-Host "Max Number of Characters for this password is: " ($MaxNumber+1) -ForegroundColor Yellow 

#Create random password
$Password = New-Object -TypeName PSObject
$Password | Add-Member `
    -MemberType ScriptProperty `
    -Name "Password" `
    -Value {
        ($Chars.tochararray() | Sort-Object {Get-Random})[0..$MaxNumber] -join ''
    }

Write-Host "The password is: " -ForegroundColor Green -NoNewline
Write-Host ($Password | Select-Object -ExpandProperty "Password") -ForegroundColor White
Write-Host "The password length is: " -ForegroundColor Green -NoNewline
Write-Host ($Password | Select-Object -ExpandProperty "Password").Length





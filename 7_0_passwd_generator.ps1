#This script generates random password and returns it to the function initiator (any other script)
function CreatePassword (){

    #Initiating the neccessary parameters
    param (
        $Chars = "!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz",
        $Min = 8,
        $Max = 12
    )

    #Choosing the random characters number in this password:
    $MaxNumber = Get-Random -Minimum $Min -Maximum $Max

    #Creating a dynamic password object
    $Passwd = New-Object -TypeName PSObject
    $Passwd | Add-Member `
        -MemberType ScriptProperty `
        -Name "Password" `
        -Value {($Chars.ToCharArray() | Sort-Object {Get-Random})[0..$MaxNumber] -join ''}

    #Return the password to the initiator of the function
    $($Passwd | Select-Object -ExpandProperty "Password")
}

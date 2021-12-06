function CreatePassword (){

    #Initiating the neccessary parameters
    param (
        $Chars = "!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz",
        $Min = 8,
        $Max = 12
    )

    #Choosing the random characters number in this password:
    $MaxNumber = Get-Random -Minimum $Min -Maximum $Max

    #Create random password
    $Password = New-Object -TypeName PSObject
    $Password | Add-Member `
    -MemberType ScriptProperty `
    -Name "Password" `
    -Value {
        ($Chars.tochararray() | Sort-Object {Get-Random})[0..$MaxNumber] -join ''
    }

    #Return the password to the initiator of the function
    $($Password | Select-Object -ExpandProperty "Password")
}

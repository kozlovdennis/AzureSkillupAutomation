#Install powershell 7 and open it
#Enable powershell for azure
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

#Check the commands quantity
Write-Host "Number of Az commands: " (Get-Command -Module Az).count


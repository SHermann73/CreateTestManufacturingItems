$OldVersion="14.0.0.24"
$NewVersion="14.0.0.25"

$Servicetier="BC180W1"
$AppName="Create Manufacturing Items"
$Path="C:\Users\Peikba\Documents\AL\Create Manuf Items\Default publisher_Create Manuf Items_1.0.0.0.app"

$Path2="C:\Users\Peikba\Documents\AL\Ferrum_14\RelateIT AS_RIT Ferrum Customizations_14.13.0.217.app"

Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\180\Service\NavAdminTool.ps1'
# Uninstall the app 
Uninstall-NAVApp  -ServerInstance $Servicetier -Name $AppName -Version $OldVersion
# Publish app to database
Publish-NAVApp -ServerInstance $Servicetier -Path $Path -SkipVerification
Sync-NAVApp -ServerInstance $Servicetier -Name $AppName -version $NewVersion -Mode ForceSync
Start-NAVAppDataUpgrade -ServerInstance $Servicetier -Name $AppName -Version $NewVersion
# Install in tenant
Unpublish-NAVApp -ServerInstance "Ferrum" -Name "Ferrum" -Version $OldVersion



Publish-NAVApp -ServerInstance $Servicetier -Path $Path -SkipVerification
Install-NAVApp -ServerInstance $Servicetier -Name "RIT Ferrum Customizations" -Version "14.13.0.217"
Unpublish-NAVApp -ServerInstance "Ferrum" -Name "RIT Ferrum Customizations" -Version "14.13.0.217"



Unpublish-NAVApp -ServerInstance "Ferrum" -Name "Ferrum" -Version $NewVersion


Set-ExecutionPolicy RemoteSigned
# Import the module for the  cmdLet
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1'
# Get infoemation of Apps
Get-NAVAppInfo -ServerInstance $Servicetier



# Uninstall the app - Save the data
Uninstall-NAVApp  -ServerInstance $Servicetier -Name $AppName 
# Remove the app from the database - but keep the tables
Unpublish-NAVApp -ServerInstance "Ferrum" -Name "Ferrum"
# Publish app to database
Publish-NAVApp -ServerInstance $Servicetier -Path $Path -SkipVerification
# Install in tenant
Install-NAVApp -ServerInstance $Servicetier -Name $AppName
Date


Sync-NAVTenant -ServerInstance $Servicetier -Mode ForceSync
Sync-NAVApp -ServerInstance $Servicetier -Name $AppName -version $NewVersion

# Remove the tables if the app is gone
Sync-NAVApp -ServerInstance $Servicetier -Name $AppName # -Mode Clean

Import-NAVServerLicense -ServerInstance "Ferrum" -LicenseFile "C:\Install\Agidon 2018 DEV 5410673.flf"




<#
.SYNOPSIS
	Scrapes system information from managed endpoints.

.DESCRIPTION
	This script retrieves the endpoint's First Physical Disk Serial Number.

.NOTES
	Company: SilentPS, LLC
	URL: https://silentps.com 
	Created On: 21 January, 2024
	Modified: 28 Febuarary, 2025
	Version: 1.0
	License: All Rights Reserved

.LINK
	https://github.com/SilentPSLLC/NinjaOne-Scripts/
     
.EXAMPLE
	./Get-SysInfo-DiskSerial.ps1
#>    


# Get the name of the installed processor
$DiskSerial = (Get-PhysicalDisk | Select-Object -First 1 SerialNumber).SerialNumber
$OldDiskSerial = Ninja-Property-Get StorageDriveSerial

# Update and Return $DiskName
Ninja-Property-Set StorageDriveSerial $DiskSerial
Write-Host "Updated Disk Serial Number from $OldDiskSerial to $DiskSerial Successfully"

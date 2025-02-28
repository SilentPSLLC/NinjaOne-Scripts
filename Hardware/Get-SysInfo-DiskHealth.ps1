<#
.SYNOPSIS
  Scrapes system information from managed endpoints.

.DESCRIPTION
	This script retrieves the endpoint's First Physical Disk Health Status.

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
	./Get-SysInfo-DiskHealth.ps1
#>    

# Get the name of the installed processor
$DiskHealth = (Get-PhysicalDisk | Select-Object -First 1 HealthStatus).HealthStatus
$OldDiskHealth = Ninja-Property-Get StorageDiskHealth

# Update and Return $DiskName
Ninja-Property-Set StorageDiskHealth $DiskHealth
Write-Host "Updated Disk Serial Number from $OldDiskHealth to $DiskHealth Successfully"

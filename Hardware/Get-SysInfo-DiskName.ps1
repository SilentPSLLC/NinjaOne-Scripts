<#
.SYNOPSIS
  Scrapes system information from managed endpoints.

.DESCRIPTION
  This script retrieves the endpoint's First Physical Disk name.

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
  ./Get-SysInfo-DiskName.ps1
#>    

# Get the name of the installed processor
$DiskName = (Get-PhysicalDisk | Select-Object -First 1 FriendlyName).FriendlyName
$OldDiskName = Ninja-Property-Get StorageDiskName

# Update and Return $DiskName
Ninja-Property-Set StorageDiskName $DiskName
Write-Host "Updated Processor from $OldDiskName to $DiskName Successfully"

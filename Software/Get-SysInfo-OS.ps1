<#
.SYNOPSIS
  Scrapes system information from managed endpoints.

.DESCRIPTION
  This script retrieves the endpoint's Operating System Caption and Architecture  

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
#OSCaption = $($osInfo.Caption) Disabled, Doesn't work on all systems
$OSCaption =  (systeminfo | Select-String "OS Name" | ForEach-Object { ($_ -split ":")[1].Trim() })
$SysArchVer = if ([System.Environment]::Is64BitOperatingSystem) { "64-bit" } else { "32-bit" }
$OSName = "$OSCaption ($SysArchVer)"
$OldOSName = Ninja-Property-Get osVersion

# Update and Return $DiskName
Ninja-Property-Set osVersion $OSName
Write-Host "Updated OS Version from $OldOSName to $OSName Successfully"

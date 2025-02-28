<#
.SYNOPSIS
  Scrapes system information from managed endpoints.

.DESCRIPTION
	This script retrieves the endpoint's RAM Part Info.

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
  ./Get-SysInfo-RAM-PartInfo.ps1
#>    

# Get the name of the installed processor
$MemoryInfo = Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer, PartNumber, Capacity, Speed, SerialNumber
$OldMemoryInfo = Ninja-Property-Get memorypartnumber
$memoryDetailsList = @()  # Create an array to store memory details

# Generate a list of formatted memory details
$memoryDetailsList = $MemoryInfo | ForEach-Object {
    "$($_.Manufacturer) $($_.PartNumber) $([math]::round($_.Capacity / 1GB, 2)) GB $($_.Speed) MHz SerialNumber: $($_.SerialNumber)"
}

# Combine all entries with a pipe | if there are multiple memory modules
$combinedMemoryDetails = $memoryDetailsList -join " | "

# Update and Return memory info
Ninja-Property-Set memorypartnumber $combinedMemoryDetails
Write-Host "Updated Memory Part Number from $OldMemoryInfo to $combinedMemoryDetails Successfully"

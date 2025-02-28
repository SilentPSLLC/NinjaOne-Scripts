<#
.SYNOPSIS
	Scrapes system information from managed endpoints based on the slected parameters.

.DESCRIPTION
	This script retrieves the endpoint's SKU code as its needed durring warrenty lookup for certain systems. Primarily HP systems

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
	./Get-SysInfo-SKU.ps1
#>     
     
#Variables 
$SKU = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty SystemSKUNumber #Queries Win32_ComputerSystem for SystemSKUNumber
$OldSKU = Ninja-Property-Get computerProductId
  
  
# Update and Return $SKU
Ninja-Property-Set computerProductId $SKU
Write-Host "Updated SKU Code (Computer Product ID) from $OldSKU to $SKU Successfully"

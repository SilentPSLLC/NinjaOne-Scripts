<#
.SYNOPSIS
	Scrapes system information from managed endpoints.

.DESCRIPTION
	This script retrieves the endpoint's Processor Name.

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
	./Get-SysInfo-Processor.ps1
#>    


# Get the name of the installed processor
$Processor = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
$OldProcessor = Ninja-Property-Get Processor

# Update and Return $Processor
Ninja-Property-Set Processor $Processor
Write-Host "Updated Processor from $OldProcessor to $Processor Successfully"


<#
.SYNOPSIS
  Scrapes system information from managed endpoints.

.DESCRIPTION
  This script retrieves the endpoint's RAM type and form factor.

.NOTES
  Company: SilentPS, LLC
  URL: https://silentps.com 
  Created On: 21 January, 2024
  Modified: 28 February, 2025
  Version: 1.0
  License: All Rights Reserved

.LINK
  https://github.com/SilentPSLLC/NinjaOne-Scripts/
     
.EXAMPLE
  ./Get-SysInfo-RAMType.ps1
#>    

# Retrieve RAM information & variables
$OldRAMType = Ninja-Property-Get memorytype
try {$ramInfo = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object SMBIOSMemoryType, FormFactor} 
catch {Write-Host "Error retrieving RAM information: $_" return}

if ($ramInfo -eq $null -or $ramInfo.Count -eq 0) {Write-Host "No RAM information found." return}

# Define RAM Type mapping (SMBIOSMemoryType)
$memoryTypeMap = @{
    20  = "DDR"
    21  = "DDR2"
    22  = "DDR2 FB-DIMM"
    24  = "DDR3"
    26  = "DDR4"
    default = "Unknown"
}

# Define RAM Form Factor mapping (FormFactor)
$formFactorMap = @{
    0   = "Unknown"
    1   = "Other"
    2   = "SIP"
    3   = "DIP"
    4   = "ZIP"
    5   = "SOJ"
    6   = "Proprietary"
    7   = "SIMM"
    8   = "DIMM"
    9   = "TSOP"
    10  = "PGA"
    11  = "RIMM"
    12  = "SODIMM"
    13  = "SRIMM"
    14  = "SMD"
    15  = "SSMP"
    16  = "QFP"
    17  = "TQFP"
    18  = "SOIC"
    19  = "LCC"
    20  = "PLCC"
    21  = "BGA"
    22  = "FPBGA"
    23  = "LGA"
    default = "Unknown"
}

# Process each RAM module
foreach ($module in $ramInfo) {
    # Debugging: Print the raw values of SMBIOSMemoryType and FormFactor
    Write-Host "Raw SMBIOSMemoryType: $($module.SMBIOSMemoryType), Raw FormFactor: $($module.FormFactor)"

    # Cast to integer to ensure proper lookup
    $SMBIOSMemoryType = [int]$module.SMBIOSMemoryType
    $FormFactor = [int]$module.FormFactor

    # Get RAM type and form factor using the memoryTypeMap and formFactorMaphashtable
    $MemoryType = $memoryTypeMap[$SMBIOSMemoryType]
    if (-not $MemoryType) { $MemoryType = "Unknown" }
    $FormFactor = $formFactorMap[$FormFactor]
    if (-not $FormFactor) { $FormFactor = "Unknown" }

    # Combine RAM Form Factor and Type
    $FormFactorMemoryType = "$FormFactor $MemoryType"

    # Set the Ninja Property and display the result
    try {
        Ninja-Property-Set memorytype $FormFactorMemoryType
        Write-Host "Updated Memory Type (RAM type) from $OldRAMType to $FormFactorMemoryType"
    } catch {Write-Host "Error setting Ninja Property 'memorytype': $_"}
}

<#
.SYNOPSIS
	Scrapes system information from managed endpoints based on the slected parameters.

.DESCRIPTION
	This script retrieves information about the computer system, including but not limited to manufacturer, SKU, memory size, memory type, memory form factor, 
    domain, PC type, battery status, TPM Version and more.

.NOTES
	Company: SilentPS, LLC
  URL: https://silentps.com 
	Created On: 21 January, 2024
	Modified: 28 Febuarary, 2025
  Version: 1.2
  License: All Rights Reserved

.LINK
    https://github.com/SilentPSLLC/NinjaOne-Scripts/

.PARAMETER Get-SystemArchitecture
     Retrieves and displays system architecture of endpoint.

.PARAMETER Get-RAMInfo
     Retrieves and displays system memory type and form factor
	 
.PARAMETER Get-RAMPartNumber 
     Retrieves and displays system Memory Part Number of endpoint.
	   
.PARAMETER Get-SystemTotalMemory 
     Retrieves and displays system memory totals of endpoint.
	 
.PARAMETER Get-SystemSKUNumber 
     Retrieves and displays system Memory Part Number of endpoint.
	  
.PARAMETER Get-WindowsVersion 
     Retrieves and displays system windows version number of endpoint.
	  
.PARAMETER Get-BatteryName 
     Retrieves and displays system Battery Name of endpoint.
	  
.PARAMETER Get-BatteryPercentage 
     Retrieves and displays system battery percentageof endpoint.
	  
.PARAMETER Get-BatteryChargeCycles 
     Retrieves and displays battery charge cycles of endpoint. Note: Limited Support
     
.PARAMETER Get-BatteryEstimatedRuntime
     Retrieves and displays battery estimated runtime remaining of endpoint.
	 
.PARAMETER Get-BatteryStatus 
     Retrieves and displays battery status of endpoint.
     
.PARAMETER Get-BatteryChemistry 
     Retrieves and displays battery chemistry of endpoint.
     
.PARAMETER Get-PhysicalDiskFriendlyName
     Retrieves and displays system first disk name of endpoint.
     
.PARAMETER Get-PhysicalDiskSerialNumber 
     Retrieves and displays system first disk serialnumber of endpoint.
     
.PARAMETER Get-PhysicalDiskHealthStatus 
     Retrieves and displays system first disk healthy of endpoint.
     
.PARAMETER Get-TPMVersion 
     Retrieves and displays TPM version number of endpoint.
     
.EXAMPLE
	./Get-SystemInfo-Select.ps1
	./Get-SystemInfo-Select.ps1 -Function SystemArchitecture
	./Get-SystemInfo-Select.ps1 -Function RAMInfo
	./Get-SystemInfo-Select.ps1 -Function RAMPartNumber 
	./Get-SystemInfo-Select.ps1 -Function SystemTotalMemory 
	./Get-SystemInfo-Select.ps1 -Function SystemSKUNumber 
	./Get-SystemInfo-Select.ps1 -Function WindowsVersion
	./Get-SystemInfo-Select.ps1 -Function BatteryName
	./Get-SystemInfo-Select.ps1 -Function BatteryPercentage
	./Get-SystemInfo-Select.ps1 -Function BatteryChargeCycles
	./Get-SystemInfo-Select.ps1 -Function BatteryEstimatedRuntime
	./Get-SystemInfo-Select.ps1 -Function BatteryStatus
	./Get-SystemInfo-Select.ps1 -Function BatteryChemistry
	./Get-SystemInfo-Select.ps1 -Function LastBootTime
	./Get-SystemInfo-Select.ps1 -Function PhysicalDiskFriendlyName
	./Get-SystemInfo-Select.ps1 -Function PhysicalDiskSerialNumber
	./Get-SystemInfo-Select.ps1 -Function PhysicalDiskHealthStatus
	./Get-SystemInfo-Select.ps1 -Function TPMInfo

#>


param (
    [Parameter(Mandatory = $true)]
    [string]$Function
)

function Get-SystemArchitecture {
	try {
		$Architecture = if ([System.Environment]::Is64BitOperatingSystem) {"64-bit"} else {"32-bit"}
		Write-Host "System Architecture: $Architecture"
	} catch {Write-Error "Error getting system architecture: $_" return $null}
}

function Get-RAMInfo {
    try {
        # Retrieve RAM information
        $ramInfo = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object SMBIOSMemoryType, FormFactor
    } catch {Write-Host "Error retrieving RAM information: $_" return}

    # Process each RAM module
    foreach ($module in $ramInfo) {
        # Determine RAM type based on SMBIOSMemoryType
        switch ($module.SMBIOSMemoryType) {
            20 { $MemoryType = "DDR" }
            21 { $MemoryType = "DDR2" }
            22 { $MemoryType = "DDR2 FB-DIMM" }
            24 { $MemoryType = "DDR3" }
            26 { $MemoryType = "DDR4" }
            default { $MemoryType = "Unknown" }
        }

        # Determine RAM form factor based on FormFactor
        switch ($module.FormFactor) {
            0 { $FormFactor = "Unknown" }
            1 { $FormFactor = "Other" }
            2 { $FormFactor = "SIP" }
            3 { $FormFactor = "DIP" }
            4 { $FormFactor = "ZIP" }
            5 { $FormFactor = "SOJ" }
            6 { $FormFactor = "Proprietary" }
            7 { $FormFactor = "SIMM" }
            8 { $FormFactor = "DIMM" }
            9 { $FormFactor = "TSOP" }
            10 { $FormFactor = "PGA" }
            11 { $FormFactor = "RIMM" }
            12 { $FormFactor = "SODIMM" }
            13 { $FormFactor = "SRIMM" }
            14 { $FormFactor = "SMD" }
            15 { $FormFactor = "SSMP" }
            16 { $FormFactor = "QFP" }
            17 { $FormFactor = "TQFP" }
            18 { $FormFactor = "SOIC" }
            19 { $FormFactor = "LCC" }
            20 { $FormFactor = "PLCC" }
            21 { $FormFactor = "BGA" }
            22 { $FormFactor = "FPBGA" }
            23 { $FormFactor = "LGA" }
            default { $FormFactor = "Unknown" }
        }

        # Combine and display the result
        $FormFactorMemoryType = "$FormFactor $MemoryType"
        Write-Host "Detected RAM Type and Form Factor: $FormFactorMemoryType"
        
        # Optional: Set property in NinjaRMM (if needed)
        Ninja-Property-Set memorytype $FormFactorMemoryType
    }
}

function Get-RAMPartNumber {
    # Initialize an ArrayList to store RAM part numbers (more efficient than using an array with +=)
    $PartNumbers = New-Object System.Collections.ArrayList

    try {
        # Get information about the installed RAM including PartNumber
        $ramInfo = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -ExpandProperty PartNumber
        
        # Add each part number to the ArrayList
        $ramInfo | ForEach-Object { $PartNumbers.Add($_) }
    } catch {
        Write-Host "Error retrieving RAM part numbers: $_"
        return
    }

    # Combine part numbers into a single string
    $PartNumberString = $PartNumbers -join "| "

    # Display the part numbers
    Write-Host "RAM Part Numbers: $PartNumberString"

    # NinjaRMM: Set memory part numbers (if using NinjaRMM integration)
    Ninja-Property-Set memorypartnumber $PartNumberString
}

function Get-SystemTotalMemory {
  # Get total physical memory of the system
  $totalMemoryInBytes = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
  $totalMemoryInGB = [Math]::Round($totalMemoryInBytes / 1GB)
    
  #Set Varaible
  $totalMemory = Get-SystemTotalMemory
    
  #return $totalMemoryInGB
  Write-Host "Total Physical Memory: $totalMemory GB"
}

function Get-SystemSKUNumber {
  $SKU = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty SystemSKUNumber
  
  #return $SKU
  Write-Host "Retrieved SKU Code (Product ID): $SKU Successfully"
  Ninja-Property-Set computerProductId $SKU
}

function Get-WindowsVersion {
  $osVersion = (Get-ComputerInfo | Select-Object -ExpandProperty OSVersion) -replace '^\d+\.\d+\.', ''

  switch ($osVersion) {
    #Windows 10 Build Numbers
    "10240" { $RelID = "1507"; break } # End of Support: October 14, 2025
    "10586" { $RelID = "1511"; break } # End of Support: October 10, 2017
    "14393" { $RelID = "1607"; break } # End of Support: October 13, 2026
    "15063" { $RelID = "1703"; break } # End of Support: October 9, 2018
    "16299" { $RelID = "1709"; break } # End of Support: April 9, 2019
    "17134" { $RelID = "1803"; break } # End of Support: November 12, 2019
    "17763" { $RelID = "1809"; break } # End of Support: November 10, 2020
    "18362" { $RelID = "19H1"; break } # End of Support: December 8, 2020
    "18363" { $RelID = "19H2"; break } # End of Support: May 11, 2021
    "19041" { $RelID = "20H1"; break } # End of Support: December 14, 2021
    "19042" { $RelID = "20H2"; break } # End of Support: May 10, 2022
    "19043" { $RelID = "21H1"; break } # End of Support: December 13, 2022
    "19044" { $RelID = "21H2"; break } # End of Support: June 13, 2023
    "19045" { $RelID = "22H2"; break } # End of Support: October 14, 2025
	
    #Windows 11 Build Numbers
    "22000" { $RelID = "21H2"; break } # End of Support: October 10, 2023
    "22621" { $RelID = "22H2"; break } # End of Support: October 08, 2024
    "22631" { $RelID = "23H2"; break } # End of Support: November 11, 2025
	"26100" { $RelID = "24H2"; break } # End of Support: October 13, 2026
    "00000" { $RelID = "24H2"; break }
	
    #Windows 11 Insider Build Numbers
    "22635" { $RelID = "23H2-InsiderBuild"; break }
    
    default { "OS version does not match any known versions" }
  }
  Write-Host "Windows Release ID: $RelID"
  Ninja-Property-Set windowsReleaseId $RelID;
}

function Get-BatteryName {
   try {
        $battery = Get-WmiObject -Class Win32_Battery
        $batteryName = $battery.Name
        Write-Host "Battery Name: $batteryName"

        # NinjaRMM: Set battery Name
        Ninja-Property-Set batteryname $batteryName
        
    } catch {
        Write-Error "Error getting battery name: $_"
        return $null
    }
}	

function Get-BatteryPercentage {
  $BatteryPercentage = (Get-WmiObject -Class Win32_Battery).EstimatedChargeRemaining
  Write-Host "Battery Percentage: $BatteryPercentage%"
    
    # NinjaRMM: Set battery percentage
    Ninja-Property-Set batteryPercentage $BatteryPercentage
}

function Get-BatteryChargeCycles {
  try {
    $battery = Get-WmiObject -Class Win32_Battery
    $chargeCycles = $battery.EstimatedChargeRemaining
    Write-Host "Battery Charge Cycles: $chargeCycles"

    # Return the number of charge cycles
        return $chargeCycles
    } catch {Write-Error "Error getting battery charge cycles: $_" return $null}
} 
 
function Get-BatteryEstimatedRuntime {
  try {
    $batteryRuntime = (Get-CimInstance -ClassName Win32_Battery | Measure-Object -Property EstimatedRunTime -Average).Average
    
    # Interpret battery runtime
    if ($batteryRuntime -eq 71582788) {$runtime = "AC Power"} else {$runtime = "Estimated Runtime: {0:n1} hours." -f ($batteryRuntime / 60)}

    # Display battery estimated runtime
    Write-Host "Battery Estimated Runtime: $runtime"

    # Set battery estimated runtime using Ninja-Property-Set
    Ninja-Property-Set batteryEstimatedRuntime $runtime

    # Return battery estimated runtime
      return $runtime
    } catch {Write-Error "Error retrieving battery estimated runtime: $_"}
}

function Get-BatteryStatus {
  try {
    $batteryStatus = (Get-CimInstance -ClassName Win32_Battery).BatteryStatus
    # Interpret battery status
    switch ($batteryStatus) {
      1 { $status = 'Battery Power' }
      2 { $status = 'AC Power' }
      3 { $status = 'Fully Charged' }
      4 { $status = 'Low' }
      5 { $status = 'Critical' }
      6 { $status = 'Charging' }
      7 { $status = 'Charging and High' }
      8 { $status = 'Charging and Low' }
      9 { $status = 'Charging and Critical' }
      10 { $status = 'Undefined' }
      11 { $status = 'Partially Charged' }
      default { $status = "Unknown status: $batteryStatus" }
    }

    # Set the battery status using Ninja-Property-Set
    Ninja-Property-Set batteryStatus $status

    # Return the battery status
      return $status
    } catch {Write-Error "Error retrieving battery status: $_"}
}

function Get-BatteryChemistry {
  try {
    #Get battery chemistry
    $batteryChemistry = (Get-CimInstance -ClassName Win32_Battery).Chemistry

    # Interpret battery chemistry
    switch ($batteryChemistry) {
      { $_ -lt 1 } {$chemistry = "" }
      { $_ -eq 1 } {$chemistry = "Other" }
      { $_ -eq 2 } {$chemistry = "Unknown" }
      { $_ -eq 3 } {$chemistry = "Lead Acid" }
      { $_ -eq 4 } {$chemistry = "Nickel Cadmium" }
      { $_ -eq 5 } {$chemistry = "Nickel Metal Hydride" }
      { $_ -eq 6 } {$chemistry = "Lithium-ion" }
      { $_ -eq 7 } {$chemistry = "Zinc Air" }
      { $_ -eq 8 } {$chemistry = "Lithium Polymer" }
      { $_ -gt 8 } {$chemistry = "" }
      default { $chemistry = "Unknown chemistry: $batteryChemistry" }
    }

    # Set the battery chemistry using Ninja-Property-Set
    Ninja-Property-Set batterychemistry $chemistry

    # Return the interpreted battery chemistry
      return $chemistry
    } catch {Write-Error "Error retrieving battery chemistry: $_"}
}	

function Get-LastBootTime {
  # Retrieve the last boot time using WMI
  try {$LastBootInfo = Get-WmiObject win32_operatingsystem | Select-Object CSName, @{Name='LastBootUpTime';Expression={($_.ConvertToDateTime($_.LastBootUpTime))}}

  # Get the current time
  $CurrentTime = Get-Date

  # Calculate the time span since the last boot
  $TimeSpan = New-TimeSpan -Start $LastBootInfo.LastBootUpTime -End $CurrentTime

  # Output the results
  Write-Host "Computer Name: $($LastBootInfo.CSName)"
  Write-Host "Last Boot Up Time: $($LastBootInfo.LastBootUpTime)"
  Write-Host "Time Span Since Last Boot: $($TimeSpan.Days) Days, $($TimeSpan.Hours) Hours, $($TimeSpan.Minutes) Minutes, $($TimeSpan.Seconds) Seconds"
  } catch {Write-Error "Error retrieving last boot time: $_"} }

function Get-PhysicalDiskFriendlyName {
  # Retrieve the first physical disk's FriendlyName
  try {$physicalDisk = Get-PhysicalDisk | Select-Object -First 1 FriendlyName
      # Check if a physical disk was found
      if ($physicalDisk) {Write-Host "First Physical Disk FriendlyName: $($physicalDisk.FriendlyName)"} 
      else {Write-Host "No physical disks found."}
    } catch {Write-Error "Error retrieving physical disk information: $_"}
    
    Ninja-Property-Set StorageDriveModel $physicalDisk.FriendlyName
}

function Get-PhysicalDiskSerialNumber {
  try {
    # Retrieve the first physical disk's SerialNumber
    $physicalDisk = Get-PhysicalDisk | Select-Object -First 1 SerialNumber
        
    # Check if a physical disk was found
    if ($physicalDisk) {
      Write-Host "First Physical Disk SerialNumber: $($physicalDisk.SerialNumber)"
    } else {Write-Host "No physical disks found."  }
    } catch {Write-Error "Error retrieving physical disk information: $_"}
}

function Get-PhysicalDiskHealthStatus {
  try {
    # Retrieve the first physical disk's HealthStatus
    $physicalDisk = Get-PhysicalDisk | Select-Object -First 1 HealthStatus
    
    # Check if a physical disk was found
    if ($physicalDisk) {
      Write-Host "First Physical Disk Health Status: $($physicalDisk.HealthStatus)"
    } else {Write-Host "No physical disks found."}
    } catch {Write-Error "Error retrieving physical disk health status: $_"}
}

function Get-TPMversion {
  # Define TPM Version Mapping (GUID -> Human Readable)
  $TPMVersionMap = @{
    "2c12064a-8fa8-4856-be3b-8ec7d4afd827" = "Unknown"
    "e1986642-d42e-4593-bcc7-51ddb079a61a" = "Not Present"
    "1b49c0de-faba-4265-8b38-3e845313665c" = "1.0"
    "f52af764-ebd0-4e32-b1ce-b599ab36a20b" = "1.5"
    "7022bd76-b3e9-431f-b04f-3464187b9c2b" = "2.0"
    "106fc692-17fc-4164-aca7-1e192a511d67" = "2.5"
  }

  # Fetch TPM Information
  $GetTPM = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm

  # Default to "Not Present"
  $TPMVersionGUID = "e1986642-d42e-4593-bcc7-51ddb079a61a"  # Not Present

  # Check if TPM exists
  if ($GetTPM) {
    $SpecVersion = $GetTPM.SpecVersion
    Write-Host "Detected TPM Spec Version: $SpecVersion"

    switch -Wildcard ($SpecVersion) {
        "*Not Present*" { $TPMVersionGUID = "e1986642-d42e-4593-bcc7-51ddb079a61a" }
        "*1.0*" { $TPMVersionGUID = "1b49c0de-faba-4265-8b38-3e845313665c" }
        "*1.5*" { $TPMVersionGUID = "f52af764-ebd0-4e32-b1ce-b599ab36a20b" }
        "*2.0*" { $TPMVersionGUID = "7022bd76-b3e9-431f-b04f-3464187b9c2b" } # Required miniumums for Windows 11
        "*2.5*" { $TPMVersionGUID = "106fc692-17fc-4164-aca7-1e192a511d67" }
        Default { $TPMVersionGUID = "2c12064a-8fa8-4856-be3b-8ec7d4afd827" } # Unknown
    }
  } else {Write-Host "No TPM detected."}

# Debugging Property Set
Write-Host "Setting TPM Version GUID to: $TPMVersionGUID"

# Send GUID to NinjaOne
Ninja-Property-Set tpmVersion $TPMVersionGUID

# Final Debugging Confirmation
Write-Host "Successfully updated NinjaOne properties."

# Display Human-Readable Output
Write-Host "TPM Version: $($TPMVersionMap[$TPMVersionGUID])"
}

# Main script logic
switch ($Function) {
  "SystemArchitecture" {Get-SystemArchitecture}
  "RAMInfo" {Get-RAMInfo}
  "RAMPartNumber" {Get-RAMPartNumber}
  "SystemTotalMemory" {Get-SystemTotalMemory}
  "SystemSKUNumber" {Get-SystemSKUNumber}
  "WindowsVersion" {Get-WindowsVersion}
  "BatteryName" {Get-BatteryName}  
  "BatteryPercentage" {Get-BatteryPercentage}
  "BatteryChargeCycles" {Get-BatteryChargeCycles}
  "BatteryEstimatedRuntime" {Get-BatteryEstimatedRuntime}
  "BatteryStatus" {Get-BatteryStatus}
  "BatteryChemistry" {Get-BatteryChemistry}
  "LastBootTime" {Get-LastBootTime}
  "PhysicalDiskFriendlyName" {Get-PhysicalDiskFriendlyName}
  "PhysicalDiskSerialNumber" {Get-FirstPhysicalDiskSerialNumber}
  "PhysicalDiskHealthStatus" {Get-PhysicalDiskHealthStatus}
  "TPMversion" {Get-TPMversion}
  "TPMInfo" {Get-TPMInfo}
  
  
  default {Write-Error "Invalid function specified. Supported functions: SystemArchitecture, RAMInfo, RAMPartNumber, SystemTotalMemory, SystemTotalMemory, SystemSKUNumber, WindowsVersion, BatteryName, BatteryPercentage, BatteryChargeCycles, BatteryEstimatedRuntime, BatteryStatus, BatteryChemistry, LastBootTime, PhysicalDiskFriendlyName, PhysicalDiskSerialNumber, PhysicalDiskHealthStatus "}
}

  








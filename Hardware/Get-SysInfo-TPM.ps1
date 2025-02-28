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

# Define TPM Version Mapping (GUID -> Human Readable)
  $TPMVersionMap = @{
    "17f564d8-e842-497d-8e0b-5e856cd0af2e" = "2.5"
    "a3910e2b-57b8-47ae-9caf-6768b97ffc0c" = "2.0"
    "14752995-6e05-4a47-b758-0e120b6adb45" = "1.0"
    "5a0c94f0-1a8c-48ee-97e1-80d900511cad" = "1.5"
    "65ba5650-df06-4021-aafa-b4720dd7b6b1" = "Not Present"
    "1a379091-81c3-4074-a5fd-8c2b30a1590c" = "Unknown"
  }

  # Fetch TPM Information
  $GetTPM = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm
  $GetOldTPMVersion = Ninja-Property-Get tpmVersion

  # Default to "Not Present"
  $TPMVersionGUID = "e1986642-d42e-4593-bcc7-51ddb079a61a"  # Not Present

  # Check if TPM exists
  if ($GetTPM) {
    $SpecVersion = $GetTPM.SpecVersion
    Write-Host "Detected TPM Spec Version: $SpecVersion"

    switch -Wildcard ($SpecVersion) {
        "*Not Present*" { $TPMVersionGUID = "65ba5650-df06-4021-aafa-b4720dd7b6b1" } # Not Present
        "*1.0*" { $TPMVersionGUID = "14752995-6e05-4a47-b758-0e120b6adb45" } # 1.0
        "*1.5*" { $TPMVersionGUID = "5a0c94f0-1a8c-48ee-97e1-80d900511cad" } # 1.5
        "*2.0*" { $TPMVersionGUID = "a3910e2b-57b8-47ae-9caf-6768b97ffc0c" } # 2.0 Required miniumums for Windows 11
        "*2.5*" { $TPMVersionGUID = "17f564d8-e842-497d-8e0b-5e856cd0af2e" } # 2.5
        Default { $TPMVersionGUID = "1a379091-81c3-4074-a5fd-8c2b30a1590c" } # Unknown
    }
  } else {Write-Host "No TPM detected."}

# Update & Return TPM Version information
Ninja-Property-Set tpmVersion $TPMVersionGUID
Write-Host "Updated TPM Version from $GetOldTPMVersion to: $($TPMVersionMap[$TPMVersionGUID]) ($TPMVersionGUID)"
Write-Host "GUID List: "
Write-Host "17f564d8-e842-497d-8e0b-5e856cd0af2e (2.5)"
Write-Host "a3910e2b-57b8-47ae-9caf-6768b97ffc0c (2.0)"
Write-Host "14752995-6e05-4a47-b758-0e120b6adb45 (1.0)"
Write-Host "5a0c94f0-1a8c-48ee-97e1-80d900511cad (1.5)"
Write-Host "65ba5650-df06-4021-aafa-b4720dd7b6b1 (Not Present)"
Write-Host "1a379091-81c3-4074-a5fd-8c2b30a1590c (Unknown)"

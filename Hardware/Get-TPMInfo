<#
.SYNOPSIS
    Grabs all the information needed to determine Windows 11 compatibility

.DESCRIPTION
    This code will query the machine for and scrape data used to determine Windows 11 compatability including TPM, CPU, Memory, Hard Drive Space, OS Version and More

.NOTES
    Author: Christopher Sparrowgrove
    Date: 20 Sept 2023
    Version: 1.0
    License: Proprietary. All Rights Reserved.
    License URI: https://itninjastechnology.com/?page=licensing

.LINK
    https://itninjastechnology.com/page=automation

.CREDITS
This script was created with the assistance of ChatGPT (https://openai.com/) - the language model trained by OpenAI.

#>

# Check if TPM is present
$tpm = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm

# Initialize variables
$tpmVersion = "Not Present"
$tpmCompatibility = $false

# If TPM is present, get the version
if ($tpm) {
    $tpmVersion = $tpm.SpecVersion
    $tpmCompatibility = $tpmVersion -match "2.0"
}

# Set the Ninja-Property-Set variables
Ninja-Property-Set tpmVersion $tpmVersion
Ninja-Property-Set windows11CompatibilityTpm $tpmCompatibility

# Display a confirmation message
Write-Host "TPM Version: $tpmVersion"
Write-Host "Windows 11 Compatible TPM: $tpmCompatibility"

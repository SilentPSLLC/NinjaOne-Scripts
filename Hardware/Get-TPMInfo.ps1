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

# Define Variables
$GetTPM = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm
$TPMver = "Not Present"
$TPMCompatibility = $false

# Run Logic: Check if TPM is present and its version matches 2.0
if ($$GetTPM) {
    # Check if the TPM version is exactly 2.0
    if ($GetTPM.SpecVersion -match "2.0") {
        $TPMver = "2.0"
        $TPMCompatibility = $true
    }
}

# Set the Ninja-Property-Set variables
Ninja-Property-Set tpmVersion $tpmVersion
Ninja-Property-Set CompatibleTPM $tpmVersion

# Display a confirmation message
Write-Host "TPM Version: $TPMver"
Write-Host "Windows 11 Compatible TPM: $TPMCompatibility"

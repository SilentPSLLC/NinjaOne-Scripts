<#
.SYNOPSIS
    Grabs all the information needed to determine Windows 11 compatibility

.DESCRIPTION
    This code will query the machine for and scrape data used to determine Windows 11 compatability including TPM, CPU, Memory, Hard Drive Space, OS Version and More

.NinjaOne Definations
    TPMver =
            2c12064a-8fa8-4856-be3b-8ec7d4afd827 = Unknown
            e1986642-d42e-4593-bcc7-51ddb079a61a = Not Present
            1b49c0de-faba-4265-8b38-3e845313665c = 1.0
            f52af764-ebd0-4e32-b1ce-b599ab36a20b = 1.5
            7022bd76-b3e9-431f-b04f-3464187b9c2b = 2.0
            106fc692-17fc-4164-aca7-1e192a511d67 = 2.5
    TPMCompatibility = 
            0cbd061a-8687-4b8b-b0a9-517f45b978ad = False
            44f8f66d-add4-4e72-9b50-98848fa90371 = Unknown
            c20ae679-d2fd-4f90-8614-5f58b413b81d = True
.NOTES
    Author: SilentPS, LLC
    Date: 26 FEBUARY 2025
    Version: 2.0
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

# Define TPM Version Mapping (GUID -> Human Readable)
$TPMVersionMap = @{
    "2c12064a-8fa8-4856-be3b-8ec7d4afd827" = "Unknown"
    "e1986642-d42e-4593-bcc7-51ddb079a61a" = "Not Present"
    "1b49c0de-faba-4265-8b38-3e845313665c" = "1.0"
    "f52af764-ebd0-4e32-b1ce-b599ab36a20b" = "1.5"
    "7022bd76-b3e9-431f-b04f-3464187b9c2b" = "2.0"
    "106fc692-17fc-4164-aca7-1e192a511d67" = "2.5"
}

# Define TPM Compatibility Mapping (GUID -> Human Readable)
$TPMCompatibilityMap = @{
    "0cbd061a-8687-4b8b-b0a9-517f45b978ad" = "False"
    "44f8f66d-add4-4e72-9b50-98848fa90371" = "Unknown"
    "c20ae679-d2fd-4f90-8614-5f58b413b81d" = "True"
}

# Fetch TPM Information
$GetTPM = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm

# Default to "Not Present"
$TPMVersionGUID = "e1986642-d42e-4593-bcc7-51ddb079a61a"  # Not Present
$TPMCompatibilityGUID = "0cbd061a-8687-4b8b-b0a9-517f45b978ad"  # False

# Check if TPM exists
if ($GetTPM) {
    $SpecVersion = $GetTPM.SpecVersion
    Write-Host "Detected TPM Spec Version: $SpecVersion"

    switch -Wildcard ($SpecVersion) {
        "*Not Present*" { $TPMVersionGUID = "e1986642-d42e-4593-bcc7-51ddb079a61a" }
        "*1.0*" { $TPMVersionGUID = "1b49c0de-faba-4265-8b38-3e845313665c" }
        "*1.5*" { $TPMVersionGUID = "f52af764-ebd0-4e32-b1ce-b599ab36a20b" }
        "*2.0*" { $TPMVersionGUID = "7022bd76-b3e9-431f-b04f-3464187b9c2b" }
        "*2.5*" { $TPMVersionGUID = "106fc692-17fc-4164-aca7-1e192a511d67" }
        Default { $TPMVersionGUID = "2c12064a-8fa8-4856-be3b-8ec7d4afd827" } # Unknown
    }

    # Determine TPM Compatibility
    if ($TPMVersionGUID -eq "7022bd76-b3e9-431f-b04f-3464187b9c2b" -or $TPMVersionGUID -eq "106fc692-17fc-4164-aca7-1e192a511d67") {
        $TPMCompatibilityGUID = "c20ae679-d2fd-4f90-8614-5f58b413b81d"  # True (Compatible)
    } elseif ($TPMVersionGUID -eq "e1986642-d42e-4593-bcc7-51ddb079a61a") {
        $TPMCompatibilityGUID = "0cbd061a-8687-4b8b-b0a9-517f45b978ad"  # False (Not Present)
    } else {
        $TPMCompatibilityGUID = "44f8f66d-add4-4e72-9b50-98848fa90371"  # Unknown
    }
} else {
    Write-Host "No TPM detected."
}

# Debugging Property Set
Write-Host "Setting TPM Version GUID to: $TPMVersionGUID"
Write-Host "Setting TPM Compatibility GUID to: $TPMCompatibilityGUID"

# Send GUIDs to NinjaOne
Ninja-Property-Set tpmVersion $TPMVersionGUID
Ninja-Property-Set CompatibleTPM $TPMCompatibilityGUID

# Final Debugging Confirmation
Write-Host "Successfully updated NinjaOne properties."

# Display Human-Readable Output
Write-Host "TPM Version: $($TPMVersionMap[$TPMVersionGUID])"
Write-Host "Windows 11 Compatible TPM: $($TPMCompatibilityMap[$TPMCompatibilityGUID])"

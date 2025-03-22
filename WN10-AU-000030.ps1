<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Pavan Kumar Davar
    LinkedIn        : linkedin.com/in/pavan-kumar-davar/
    GitHub          : github.com/SPANKYWOWWOW
    Date Created    : 03/22/2025
    Last Modified   : 03/22/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000030

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000030).ps1 
#>
# Define the registry path and value name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regValueName = "SCENoApplyLegacyAuditPolicy"
$desiredValue = 1

# Check if the registry value exists and is correctly configured
if (Test-Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue

    if ($null -eq $currentValue) {
        Write-Host "The registry value '$regValueName' does not exist. Creating it with value $desiredValue."
        Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue
    }
    elseif ($currentValue.$regValueName -ne $desiredValue) {
        Write-Host "The registry value '$regValueName' exists but has an incorrect value. Setting it to $desiredValue."
        Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue
    }
    else {
        Write-Host "The registry value '$regValueName' is correctly configured."
    }
} else {
    Write-Host "The registry path '$regPath' does not exist."
}

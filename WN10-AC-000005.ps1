<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Pavan Kumar Davar
    LinkedIn        : linkedin.com/in/pavan-kumar-davar/
    GitHub          : github.com/SPANKYWOWWOW
    Date Created    : 03/23/2025
    Last Modified   : 03/23/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AC-000005).ps1 
#>
# Function to get the current Account Lockout Duration policy setting
function Get-AccountLockoutDuration {
    $lockoutDuration = (secedit /export /areas SECURITYPOLICY /cfg $env:TEMP\secpol.cfg) | Out-Null
    $lockoutDuration = Get-Content "$env:TEMP\secpol.cfg" | Select-String "LockoutDuration"
    if ($lockoutDuration -match "(\d+)")
    {
        return [int]$matches[1]
    }
    return $null
}

# Function to set the Account Lockout Duration policy
function Set-AccountLockoutDuration {
    param (
        [int]$duration
    )

    $infPath = "$env:TEMP\secpol.inf"
    secedit /export /areas SECURITYPOLICY /cfg $infPath | Out-Null

    (Get-Content $infPath) -replace "LockoutDuration = \d+", "LockoutDuration = $duration" | Set-Content $infPath

    secedit /configure /db c:\windows\security\local.sdb /cfg $infPath /areas SECURITYPOLICY /quiet | Out-Null
    gpupdate /force | Out-Null

    Write-Host "Fix applied: Account lockout duration set to $duration minutes." -ForegroundColor Cyan
}

# Check current setting
$currentDuration = Get-AccountLockoutDuration

if ($currentDuration -eq $null) {
    Write-Host "Error: Could not retrieve account lockout duration." -ForegroundColor Red
} elseif ($currentDuration -eq 0 -or $currentDuration -ge 15) {
    Write-Host "Compliant: Account lockout duration is set to $currentDuration minutes." -ForegroundColor Green
} else {
    Write-Host "Finding: Account lockout duration is set to $currentDuration minutes, which is less than 15. Applying fix..." -ForegroundColor Yellow
    Set-AccountLockoutDuration -duration 15
}

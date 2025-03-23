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
    STIG-ID         : WN10-AU-000070

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000070).ps1 
#>
# Define Registry Path and Expected Value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "InactivityTimeoutSecs"
$expectedValue = 900

# Check if registry key exists
if (Test-Path $regPath) {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    if ($regValue -and $regValue.$regName -le $expectedValue -and $regValue.$regName -ne 0) {
        Write-Host "Compliant: InactivityTimeoutSecs is correctly set to $($regValue.$regName) seconds" -ForegroundColor Green
    } else {
        Write-Host "Finding: InactivityTimeoutSecs is missing or incorrectly set. Applying fix..." -ForegroundColor Yellow
        Set-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -Type DWord
        Write-Host "Fix applied: InactivityTimeoutSecs is now set to $expectedValue seconds" -ForegroundColor Cyan
    }
} else {
    Write-Host "Finding: Registry path does not exist. Creating path and applying fix..." -ForegroundColor Red
    New-Item -Path $regPath -Force | Out-Null
    New-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -PropertyType DWord -Force | Out-Null
    Write-Host "Fix applied: Registry path and InactivityTimeoutSecs set to $expectedValue seconds" -ForegroundColor Cyan
}

# Force policy update
gpupdate /force | Out-Null
Write-Host "Group Policy updated. Please restart the system if needed." -ForegroundColor Magenta

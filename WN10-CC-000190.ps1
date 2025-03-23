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
    STIG-ID         : WN10-CC-000190

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-CC-000190).ps1 
#>
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regName = "NoDriveTypeAutoRun"
$expectedValue = 0xFF  # 255 in decimal

# Ensure registry key exists and is correctly set
if ((Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue).$regName -ne $expectedValue) {
    Write-Host "Finding: NoDriveTypeAutoRun is missing or incorrectly set. Applying fix..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -Type DWord
    Write-Host "Fix applied: NoDriveTypeAutoRun is now set to 255 (0xFF)" -ForegroundColor Cyan
} else {
    Write-Host "Compliant: NoDriveTypeAutoRun is correctly set to 255 (0xFF)" -ForegroundColor Green
}

# Apply Group Policy changes
gpupdate /force | Out-Null
Write-Host "Group Policy updated. Restart may be required." -ForegroundColor Magenta

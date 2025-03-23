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
    STIG-ID         : WN10-AU-000065

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000065).ps1 
#>
# Define Registry Path and Expected Value
$regPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$regName = "AutoConnectAllowedOEM"
$expectedValue = 0

# Check if the registry key exists
if (Test-Path $regPath) {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    if ($regValue -and $regValue.$regName -eq $expectedValue) {
        Write-Host "Compliant: AutoConnectAllowedOEM is correctly set to 0" -ForegroundColor Green
    } else {
        Write-Host "Finding: AutoConnectAllowedOEM is missing or incorrectly set. Applying fix..." -ForegroundColor Yellow
        Set-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -Type DWord
        Write-Host "Fix applied: AutoConnectAllowedOEM is now set to 0" -ForegroundColor Cyan
    }
} else {
    Write-Host "Finding: Registry path does not exist. Creating path and applying fix..." -ForegroundColor Red
    New-Item -Path $regPath -Force | Out-Null
    New-ItemProperty -Path $regPath -Name $regName -Value $expectedValue -PropertyType DWord -Force | Out-Null
    Write-Host "Fix applied: Registry path and AutoConnectAllowedOEM set to 0" -ForegroundColor Cyan
}

# Force policy update
gpupdate /force | Out-Null
Write-Host "Group Policy updated. Please restart the system if needed." -ForegroundColor Magenta

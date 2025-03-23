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
    STIG-ID         : WN10-CC-000165

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-CC-000165).ps1 
#>
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc"
$RegName = "RestrictRemoteClients"
$RegValue = 1

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Type DWord

Write-Output "RestrictRemoteClients has been set to $RegValue. Please restart the system or run 'gpupdate /force' for changes to take effect."

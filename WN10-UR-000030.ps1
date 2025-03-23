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
$SeceditCfg = "$env:TEMP\secpol.cfg"

# Export current security policy
secedit /export /cfg $SeceditCfg

# Modify the policy file to restrict backup rights to Administrators only
(Get-Content $SeceditCfg) -replace "(SeBackupPrivilege =).*", 'SeBackupPrivilege = Administrators' | Set-Content $SeceditCfg

# Apply the updated security policy
secedit /configure /db c:\windows\security\local.sdb /cfg $SeceditCfg /areas USER_RIGHTS

Write-Output "'Back up files and directories' right has been restricted to Administrators. Restart the system or run 'gpupdate /force' for changes to take effect."

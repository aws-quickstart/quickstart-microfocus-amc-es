[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName,

    [Parameter(Mandatory=$true)]
    [string]$TaskArguments,

    [Parameter(Mandatory=$true)]
    [String]$DomainUserName,

    [Parameter(Mandatory=$true)]
    [string]$DomainUserPassword
)

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

    # Schedule the Add-DNS call to run as <domain>\<domainuser> 10s from now and then delete the task 60s later
    $run = Get-Date
    Register-ScheduledTask `
        -TaskName "$TaskName Task"  `
        -User "$DomainUserName" `
        -Password "$DomainUserPassword" `
        -InputObject ( `
            (
                New-ScheduledTask -Action (
                    New-ScheduledTaskAction `
                        -Execute (Get-Command Powershell).Definition `
                        -Argument $TaskArguments
                ) `
                -Trigger (
                    New-ScheduledTaskTrigger -Once -At $run.AddSeconds(5)
                ) `
                -Settings (
                    New-ScheduledTaskSettingsSet  -DeleteExpiredTaskAfter 00:00:01 # Delete one second after trigger expires
                ) 
            ) | %{ $_.Triggers[0].EndBoundary = $run.AddSeconds(65).ToString('s') ; $_ } # Run through a pipe to set the end boundary of the trigger
    )
} catch {
    $_ | Write-AWSQuickStartException
}
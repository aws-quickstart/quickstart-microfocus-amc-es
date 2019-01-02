[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName,

    [Parameter(Mandatory=$true)]
    [String]$StartName,

    [Parameter(Mandatory=$true)]
    [string]$StartPassword
)

function WaitFor-ServiceStatus([Parameter(Mandatory=$true)][String]$ServiceName, [Parameter(Mandatory=$true)][string]$ExpectedState) {
    $service = Get-Service -Name $ServiceName

    # Wait for service to stop
    $i = 18
    while ($service.Status -ne $ExpectedState) {
        if (($i--) -eq 0) {
            throw "Windows Service $ServiceName failed to reach to reach '$ExpectedState' state"
        }
        write-host "waiting for service $ServiceName to reach '$ExpectedState' state..."
        Start-Sleep -Seconds 10
        $service.Refresh()
    } 
}

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

    $service = gwmi win32_service -filter "name='$ServiceName'"

    $service.StopService()
    WaitFor-ServiceStatus -ServiceName $ServiceName -ExpectedState 'Stopped'
    $ret = $service.change($null,$null,$null,$null,$null,$false,"$StartName","$StartPassword")

    $service.StartService()
    WaitFor-ServiceStatus -ServiceName $ServiceName -ExpectedState 'Running'

} catch {
    $_ | Write-AWSQuickStartException
}
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$RegionName
)

try {
    $ErrorActionPreference = "Stop"
     Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
	& "C:\Program Files (x86)\Micro Focus\Enterprise Server\bin\casstart.exe" -r"$RegionName" -s:c

} catch {
      $_ | Write-AWSQuickStartException
}
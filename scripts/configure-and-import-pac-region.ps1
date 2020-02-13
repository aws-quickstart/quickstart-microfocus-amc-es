[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Regionname
)
try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop"
    function ImportRegion {
        param (
            [Parameter(Mandatory=$true)][String]$RegionName
        )
        & "C:\Program Files (x86)\Micro Focus\Enterprise Server\bin\mfds" /g 5 C:\BankDemo_PAC\Repo\$RegionName.xml D
    }
    ImportRegion -RegionName $Regionname

}
catch {
    $_ | Write-AWSQuickStartException
}
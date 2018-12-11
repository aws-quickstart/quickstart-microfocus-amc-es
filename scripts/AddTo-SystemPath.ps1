[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [array]$PathToAdd
)

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

    $oldPath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path
    $newPath = $oldPath

    Foreach ($Path in $PathToAdd) {
        Write-Debug "Path=$Path"
        if ($newPath -like "*$Path*") {
            Write-Debug "Current item in path is: $Path"
            Write-Debug "$Path already exists in Path statement"
        } else
        {
            $newPath += ";$Path"
            Write-Debug "`$VerifiedPathsToAdd updated to contain: $Path"
        }
    }

    if ($newPath -ne $oldPath) {
        Write-Debug "Calling Set-ItemProperty -Name PATH -Value $newPath"
        [Environment]::SetEnvironmentVariable("Path", $env:Path + $newPath, [EnvironmentVariableTarget]::Machine)
    }

} catch {
    $_ | Write-AWSQuickStartException
}
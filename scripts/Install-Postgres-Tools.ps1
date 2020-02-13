try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";
    c:\cfn\assets\postgres-11-winx64.exe --unattendedmodeui none --mode unattended --disable-components "server,pgAdmin,stackbuilder" --install_runtimes 0
    Start-Sleep -s 60
    & "C:\Program Files\PostgreSQL\11\installer\vcredist_x64.exe" /quiet /norestart
}
catch {
    $_ | Write-AWSQuickStartException
}
try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";
    New-Item -ItemType Directory -Force -Path "c:\cfn\assets\"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest "https://get.enterprisedb.com/postgresql/postgresql-11.5-1-windows-x64.exe" -outfile "c:\cfn\assets\postgres-11-winx64.exe"
}
catch {
    $_ | Write-AWSQuickStartException
}
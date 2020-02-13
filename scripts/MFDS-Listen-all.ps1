try {
    Write-Host "Configuring Directory Server"
    $cmd = "C:\Program Files (x86)\Micro Focus\Enterprise Server\bin\mfds.exe"
    Start-Process -FilePath $cmd -ArgumentList "--listen-all" -Wait
    Restart-Service -Name "MF_CCITCP2"
}
catch {
    $_ | Write-AWSQuickStartException
}


[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,
    [Parameter(Mandatory=$true)]
    [string]$ServiceUser,
    [Parameter(Mandatory=$true)]
    [string]$ServicePassword
    
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    Write-Host "Updating ESCWA Service Properties"
    Stop-Service -Name "ESCWA"
    $Account="${DomainNetBIOSName}\${ServiceUser}"
    $Service=gwmi win32_service -filter "Name='ESCWA'"
    $Service.change($null,$null,$null,$null,$null,$false,$Account,$ServicePassword,$null,$null,$null)

    $Directory = "C:\ProgramData\Micro Focus\Enterprise Developer\ESCWA"
    $Inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $Propagation = [system.security.accesscontrol.PropagationFlags]"None"
    $Acl = Get-Acl $directory
    $Accessrule = New-Object system.security.AccessControl.FileSystemAccessRule($Account,"FullControl", $inherit, $propagation, "Allow")
    $Acl.AddAccessRule($Accessrule)
    Set-Acl -aclobject $Acl $Directory
    Start-Service -Name "ESCWA"
}
catch {
    $_ | Write-AWSQuickStartException
}

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [string]$DomainDnsName,

    [Parameter(Mandatory=$true)]
    [String]$DomainUserName,

    [Parameter(Mandatory=$true)]
    [string]$DomainUserPassword
)

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

	# Get the domain (netbios name) and create domain admin credentials
	$wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = `"$DomainDnsName`""
	$cred = New-Object System.Management.Automation.PSCredential `
		-ArgumentList "$($wmiDomain.DomainName)\$DomainUserName", (ConvertTo-SecureString "$DomainUserPassword" -AsPlainText -Force);

    Add-ADGroupMember -Identity "AWS delegated administrators" -Members $Username -Credential $cred

} catch {
    $_ | Write-AWSQuickStartException
}
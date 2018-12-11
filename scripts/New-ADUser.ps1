[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$NewUsername,

    [Parameter(Mandatory=$true)]
    [string]$NewUserPassword,

    [Parameter(Mandatory=$true)]
    [string]$NewUserDescription="",

    [Parameter(Mandatory=$true)]
    [string]$DomainDnsName,

    [Parameter(Mandatory=$true)]
    [String]$DomainUserName,

    [Parameter(Mandatory=$true)]
    [string]$DomainUserPassword
)

function Test-ADUser([Parameter(Mandatory=$true)][PSCredential]$Credential, [Parameter(Mandatory=$true)][string]$Username) {
    return (Get-ADUser -Credential $Credential -Filter 'Name -eq $Username' -ErrorAction Ignore)
}

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

	# Get the domain (netbios name) and create domain admin credentials
	$wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = `"$DomainDnsName`""
	$cred = New-Object System.Management.Automation.PSCredential `
		-ArgumentList "$($wmiDomain.DomainName)\$DomainUserName", (ConvertTo-SecureString "$DomainUserPassword" -AsPlainText -Force);

	if (Test-ADUser -Credential $cred -Username $NewUsername) {
		Write-Host "$NewUsername already exists"
	} else {

		New-ADUser `
			-Credential $cred `
			-Name $NewUsername `
			-AccountPassword ($NewUserPassword | ConvertTo-SecureString -AsPlainText -Force) `
			-Description $NewUserDescription `
			-Enabled 1 `
			-PasswordNeverExpires 1

		# Wait for new user to appear
		$i = 18
		do {
			if (($i--) -eq 0) {
				throw "New-ADUser Failed"
			}
			write-host "waiting for AD User '$NewUsername' to resolve..."
			Start-Sleep -Seconds 10
		} while (-not (Test-ADUser -Credential $cred -Username $NewUsername))
	}

} catch {
    $_ | Write-AWSQuickStartException
}
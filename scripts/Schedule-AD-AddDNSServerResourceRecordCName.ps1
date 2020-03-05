[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$CName,

    [Parameter(Mandatory=$true)]
    [string]$HostNameAlias,

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

    try {
        Resolve-DnsName -Type CName -Name $CName
        exit;
    } catch {
        
    }

    # Get short (NetBIOS) domain name
    $domainNetBIOSName = $(Get-WmiObject Win32_NTDomain -Filter "DnsForestName = `"$DomainDnsName`"").DomainName

    # Get DNS server addresses for the Domain
    $dnsServerAddresses = ([System.net.dns]::GetHostEntry("$DomainDnsName")).AddressList
    if ($dnsServerAddresses.Length -lt 1) {
        throw "No DNS Servers found for domain $DomainDnsName"
    }
    $dnsServerIpAddress = $dnsServerAddresses[0].IPAddressToString;
    $TName = "Add-DnsServerResourceRecordCName" + $CName
    # Schedule the Add-DNS call to run as <domain>\<domainuser> 10s from now and then delete the task 60s later
    c:\cfn\scripts\Schedule-AD-PowershellTask.ps1 `
        -TaskName "$TName" `
        -TaskArguments (
            "-Command Add-DnsServerResourceRecordCName "+ 
            "-Name $CName "+
            "-HostNameAlias $HostNameAlias "+
            "-ZoneName $DomainDnsName "+
            "-ComputerName $dnsServerIpAddress; "+
            "Sync-DnsServerZone "+
            "-Name $DomainDnsName "+
            "-ComputerName $dnsServerIpAddress "+
            "-Verbose"
        ) `
        -DomainUserName "$domainNetBIOSName\$DomainUserName" `
        -DomainUserPassword "$DomainUserPassword"

    # Wait for CName to resolve
    $i = 18
    do {
        if (($i--) -eq 0) {
            throw "DNS Failed"
        }
        write-host "waiting for $CName CNAME to resolve..."
        Start-Sleep -Seconds 10
    } while (-not (Resolve-DnsName -Name $CName -QuickTimeout -ErrorAction Ignore))

} catch {
    $_ | Write-AWSQuickStartException
}
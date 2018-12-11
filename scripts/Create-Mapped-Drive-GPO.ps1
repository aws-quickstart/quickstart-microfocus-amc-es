[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$PolicyName,

    [Parameter(Mandatory=$true)]
    [string]$DriveLetter,

    [Parameter(Mandatory=$true)]
    [string]$FileshareDataFolderUNC,

    [Parameter(Mandatory=$true)]
    [string]$DomainDnsName
)

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $ErrorActionPreference = "Stop";

    New-GPO -Name $PolicyName;
    $DomainDNSNameArray = $DomainDNSName -Split("\.")
    [int]$DomainNameFECount = 0
    $ADObjectDNArrayItemDomainName = "OU=Users,"
    ForEach ($DomainDNSNameArrayItem in $DomainDNSNameArray)
    {
        if ($DomainNameFECount -eq 0) {
            [string]$ADObjectDNArrayItemDomainName += "OU=$DomainDNSNameArrayItem,DC=$DomainDNSNameArrayItem"
        } else {
            [string]$ADObjectDNArrayItemDomainName += ",DC=" +$DomainDNSNameArrayItem
        }
        $DomainNameFECount++
    }

    New-GPLink -Name $PolicyName -Target $ADObjectDNArrayItemDomainName;
    $key = "HKCU\Network\$DriveLetter";
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName RemotePath -Type String -Value ${FileshareDataFolderUNC};
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName UserName -Type DWord -Value 0x00000000;
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName ProviderName -Type String -Value "Microsoft Windows Network";
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName ProviderType -Type DWord -Value 0x00020000;
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName ConnectionType -Type DWord -Value 0x00000001;
    Set-GPRegistryValue -Name $PolicyName -Key $key -ValueName DeferFlags -Type DWord -Value 0x00000004;

  } catch {
    $_ | Write-AWSQuickStartException
  }
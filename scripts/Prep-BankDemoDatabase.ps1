[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$DBMasterUsername,

    [Parameter(Mandatory=$true)]
    [string]$DBMasterUserPassword
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;

    # Create the BankDemo database using DB Master User
    # Note: Full path is provided because its not yet available in cfn-init parent enviroment
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -i C:\BankDemo_SQL\System\BankDemoCreateAll.SQL

    # Create ODBC DNS to the BankDemo database
    Add-OdbcDsn `
        -Name DBNASEDB `
        -DriverName "ODBC Driver 13 for SQL Server" `
        -DsnType "System" `
        -Platform "32-bit" `
        -SetPropertyValue @("Server=ESDatabase", "Trusted_Connection=Yes", "Database=BANKDEMO")

    # Create the MFDSServiceAccount SQL Login (MFDS Service runs as <domain>\MFDSServiceAccount)
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -Q "CREATE Login [$DomainNetBIOSName\MFDSServiceAccount] `
                FROM WINDOWS `
                WITH `
                    default_database=BANKDEMO, `
                    default_language=[us_english]"

    # Create the MFDSServiceAccount User in BankDemo
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -Q "USE BANKDEMO; `
             CREATE User [MFDSServiceAccount] `
               FOR LOGIN [$DomainNetBIOSName\MFDSServiceAccount]"

    # Create the Linux MFDBUser SQL Login
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -Q "CREATE Login [MFDBUser] `
                WITH `
                    PASSWORD='$DBMasterUserPassword', `
                    default_database=BANKDEMO, `
                    default_language=[us_english]"

    # Create the MFDSServiceAccount User in BankDemo
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -Q "USE BANKDEMO; `
             CREATE User [MFDBUser] `
               FOR LOGIN [MFDBUser]"
    # Grant permissions
    & "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd" `
        -S ESDatabase `
        -U $DBMasterUsername `
        -P $DBMasterUserPassword `
        -Q "USE BANKDEMO; `
             GRANT CONTROL `
               TO [MFDSServiceAccount], [MFDBUser]"
} catch {
     $_ | Write-AWSQuickStartException
}
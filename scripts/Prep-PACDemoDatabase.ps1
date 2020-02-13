[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DBMasterUsername,

    [Parameter(Mandatory=$true)]
    [string]$DBMasterUserPassword
)

try {
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    $Env:PGPASSWORD = $DBMasterUserPassword
    $Env:path += ";C:\Program Files\PostgreSQL\11\bin"
    psql -h ESPACDatabase -U $DBMasterUsername -d postgres -c "CREATE DATABASE VSAM;"
    psql -h ESPACDatabase -U $DBMasterUsername -d postgres -c "CREATE ROLE ESUser WITH login password '$DBMasterUserPassword';"
    psql -h ESPACDatabase -U $DBMasterUsername -d postgres -c "ALTER USER esuser WITH CREATEDB CREATEROLE;"
    psql -h ESPACDatabase -U $DBMasterUsername -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE VSAM TO ESUser;"
} catch {
    $_ | Write-AWSQuickStartException
}
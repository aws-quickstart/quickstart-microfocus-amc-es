[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [string]$PrivilegeName,

    [Parameter(Mandatory=$true)]
    [ValidateSet("Grant","Revoke")]
    [string]$Status
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;

    # Get SID of requested user
    $objUser = New-Object System.Security.Principal.NTAccount($Username)
    $userSID = "*"+$objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value

    # Get list of currently used SIDs in local security policy
    $tmpPath = [System.IO.Path]::GetTempPath()
    $expFile = $tmpPath+'export.inf'
    Remove-Item -path $expFile -Force -EA Ignore
    secedit /export /cfg $expFile

    # SeServiceLogonRight = *S-1-5-21-3351206321-1980276545-2487666448-1153,*S-1-5-21-3351206321-1980276545-2487666448-1154,*S-1-5-21-3351206321-1980276545-2487666448-1155
    # Remove Spaces, Isolate list of SIDs and split into an array
    $curSIDs = (Select-String $expFile -Pattern $PrivilegeName)
    if ([string]::IsNullOrEmpty($curSIDs)) {
        $curSIDs = @()  # No current SIDs, create a new empty array
    } else {
        $curSIDs =$curSIDs.Line.Replace(' ', '').Split('=')[1].Split(',')
    }

    # Try to add/remove the requested user's SID from the current list (array)
    $orgNumSIDs = $curSIDs.Count
    if ($Status -ieq 'grant') {
        if ($curSIDs -inotcontains $userSID) {
            $curSIDs += $userSID
        }
    } elseif ($Status -ieq 'revoke') {
        if ($curSIDs -icontains $userSID) {
            $curSIDs = $curSIDs | ? {$_ -ine $userSID}
        }
    }

    # If the # of SIDs changed, then update the local security policy with the new list
    if ($curSIDs.Count -ne $orgNumSIDs) {

        # Overwrite the 'SeServiceLogonRight' with the new SID list
        $newSIDS = "$PrivilegeName="+($curSIDs -join ',')

        $impFile = $tmpPath+'import.inf'
        Remove-Item -path $impFile -Force -EA Ignore

        # GrantLogOnAsAService security template
        @(
            "[Unicode]",
            "Unicode=yes",
            "[System Access]",
            "[Event Audit]",
            "[Registry Values]",
            "[Version]",
            "signature=`"`$CHICAGO$`"",
            "Revision=1", "[Profile Description]",
            "Description=$PrivilegeName security template",
            "[Privilege Rights]",
            "$newSIDs"
        ) | Out-File -FilePath $impFile

        $secFile = $tmpPath+'sedcedit.sdb'
        Remove-Item -path $secFile -Force -EA Ignore

        secedit /import /db $secFile /cfg $impFile
        secedit /configure /db $secFile /log C:\Windows\Temp\log.txt

        gpupdate /force

        Remove-Item -path $expFile -Force -EA Ignore
        Remove-Item -path $impFile -Force -EA Ignore
        Remove-Item -path $secFile -Force -EA Ignore
    } else {
        Write-Host "No change needed."
    }

} catch {
    $_ | Write-AWSQuickStartException
}

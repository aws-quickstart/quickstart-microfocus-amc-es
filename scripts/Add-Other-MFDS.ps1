param(
    [Parameter(Mandatory = $True)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory = $True)]
    [string]$ServiceUser,

    [Parameter(Mandatory = $True)]
    [string]$ServicePassword
)
try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    Write-Host "Deleting MFDS Service"
    Stop-Service -Name "MF_CCITCP2"
    $Service=gwmi win32_service -filter "Name='MF_CCITCP2'"
    $Service.delete()

    function addDS {

        Param
        (
            [Parameter(Mandatory = $true)]
            [string] $HostName,
            [Parameter(Mandatory = $true)]
            [string] $Port,
            [Parameter(Mandatory = $true)]
            [string] $Name
        )

        $JMessage = '
        {
            \"MfdsHost\": \"' + $HostName + '\",
            \"MfdsIdentifier\": \"' + $Name + '\",
            \"MfdsPort\": \"' + $Port + '\"
        }'

        $RequestURL = 'http://localhost:10004/server/v1/config/mfds'
        $Origin = 'Origin: http://localhost:10004'

        curl.exe -sX POST $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin -d $Jmessage --cookie cookie.txt | Out-Null
    }

    Write-Host "Configuring ESCWA"
    $JMessage = '{ \"mfUser\": \"\", \"mfPassword\": \"\" }'

    $RequestURL = 'http://localhost:10004/logon'
    $Origin = 'Origin: http://localhost:10004'

    curl.exe -sX POST  $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin -d $Jmessage --cookie-jar cookie.txt | Out-Null

    $RequestURL = 'http://localhost:10004/server/v1/config/mfds'
    $headers = @{
        'accept' = 'application/json'
        'Content-Type' = 'application/json'
        'X-Requested-With' = 'AgileDev'
        'Origin' = 'http://localhost:10004'
    }
    $mfdsObj = Invoke-RestMethod -URI $RequestURL -headers $headers -method 'GET'
    $Uid=$mfdsObj.Uid
    $RequestURL = "http://localhost:10004/server/v1/config/mfds/$Uid"
    curl.exe -sX DELETE $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin --cookie cookie.txt | Out-Null

    addDS -HostName "ESSERVER1" -Name "ESSERVER1" -Port "86"
    addDS -HostName "ESSERVER2" -Name "ESSERVER2" -Port "86"
}
catch {
    $_ | Write-AWSQuickStartException
}

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ESInstanceName
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path c:\cfn\log\$($MyInvocation.MyCommand.Name).txt -Append -IncludeInvocationHeader;
    Write-Host "Configuring ESCWA"
    #Logon to ESCWA
    $JMessage = '{ \"mfUser\": \"\", \"mfPassword\": \"\" }'

    $RequestURL = 'http://ESCWAInstance:10004/logon'
    $Origin = 'Origin: http://ESCWAInstance:10004'

    curl.exe -sX POST  $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin -d $Jmessage --cookie-jar cookie.txt | Out-Null
    Write-Host "Adding to PAC"
    if ($ESInstanceName -eq "ESSERVER1") {
        $RegionName = "BNKDM"
    }else {
        $RegionName = "BNKDM2"
    }
    $RequestURL = 'http://ESCWAInstance:10004/native/v1/regions/' + $ESInstanceName + '/86/' + $RegionName
    $JMessage = '
        {
            \"mfCASSOR\": \"' + ":ES_SCALE_OUT_REPOS_1=DemoPSOR=redis,ESRedis:6379##TMP" + '\",
            \"mfCASPAC\": \"' + "DemoPAC" + '\",
        }'
    curl.exe -sX PUT $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin -d $Jmessage --cookie-jar cookie.txt | Out-Null
}
catch {
    $_ | Write-AWSQuickStartException
}
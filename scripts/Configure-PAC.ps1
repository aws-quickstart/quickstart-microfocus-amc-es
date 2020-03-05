try {
    $ErrorActionPreference = "Stop"
    Write-Host "Configuring ESCWA"
    #Logon to ESCWA
    $JMessage = '{ \"mfUser\": \"\", \"mfPassword\": \"\" }'

    $RequestURL = 'http://localhost:10004/logon'
    $Origin = 'Origin: http://localhost:10004'

    curl.exe -sX POST  $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H $Origin -d $Jmessage --cookie-jar cookie.txt | Out-Null
    function MakeRequest {
        param (
            [Parameter(Mandatory = $true)][string] $RequestURL,
            [Parameter(Mandatory = $true)][string] $Jmessage
        )
        $headers = @{
            'accept' = 'application/json'
            'Content-Type' = 'application/json'
            'X-Requested-With' = 'AgileDev'
            'Origin' = 'http://localhost:10004'
        }

        $Response = Invoke-RestMethod -URI $RequestURL -headers $headers -body $Jmessage -method 'POST'
        return $Response
    }
    #Create SOR
    Write-Host "Creating SOR"
    $RequestURL = 'http://localhost:10004/server/v1/config/groups/sors'
    $JMessage = @{
            "SorName" = "DemoPSOR"
            "SorDescription" ="Demo SOR using redis"
            "SorType" = "redis"
            "SorConnectPath" = "ESRedis:6379"
        }
    $JMessage = $JMessage | ConvertTo-Json
    $Response = MakeRequest -RequestURL $RequestURL -Jmessage $JMessage
    $Uid = $Response.uid

    Write-Host "Creating PAC"
    $RequestURL = 'http://localhost:10004/server/v1/config/groups/pacs'
    $JMessage = @{
            "PacName" = "DemoPAC"
            "PacDescription" = "Demo PAC"
            "PacResourceSorUid" = "$Uid"
        }
    $JMessage = $JMessage | ConvertTo-Json
    MakeRequest -RequestURL $RequestURL -Jmessage $JMessage

}
catch {
    $_ | Write-AWSQuickStartException
}

#! /bin/bash -e

#Log output
exec > >(tee /var/log/Add-region-to-PAC.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 2 ]
then
  echo "Not Enough Arguments supplied."
  echo "Add-region-to-PAC <ESInstanceName>"
  exit 1
fi

ESInstanceName=$1
RegionName=$2
# Logon to ESCWA
RequestURL='http://ESCWAInstance:10004/logon'
Origin='Origin: http://ESCWAInstance:10004'
Jmessage='{"mfUser":"","mfPassword":""}'
curl -sX POST $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H "$Origin" -d "$Jmessage" --cookie-jar cookie.txt


RequestURL="http://ESCWAInstance:10004/native/v1/regions/${ESInstanceName}/86/${RegionName}"
echo $RequestURL
Jmessage='{"mfCASSOR":":ES_SCALE_OUT_REPOS_1=DemoPSOR=redis,ESRedis:6379##TMP","mfCASPAC":"DemoPAC"}'
echo $Jmessage
curl -sX PUT $RequestURL -H 'accept: application/json' -H 'X-Requested-With: AgileDev' -H 'Content-Type: application/json' -H "$Origin" -d "$Jmessage" --cookie-jar cookie.txt
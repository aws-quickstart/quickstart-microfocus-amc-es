#! /bin/bash -e

#Log output
exec > >(tee /var/log/Start-Region.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -lt "2" ]
then
  echo "Not Enough Arguments supplied."
  echo "Start-Region <Region name> <COBMODE>"
  exit 1
fi

Region=$1
Mode=$2
Start_Type=${3:-w}
Delay=${4:-0}
while (( "$#" )); do
    shift
done

if [ $Delay -gt "0" ]; then
    sleep $Delay
fi

source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv

export TERM="xterm"
export COBMODE=$Mode
if [ "$Start_Type" == "c" ]; then
    casstart -r$Region -s:c
else
    casstart -r$Region
fi
sleep 10
REGION_COUNT=`COLUMNS=180 ps -eaf | grep -c $Region `
#remove the entry for grep
let REGION_COUNT-=1
echo "REGION_COUNT = $REGION_COUNT"
if ( test $REGION_COUNT -lt "1")then
    echo "$Region was not started"
    exit 1
else
    echo "success"
    exit 0
fi
#! /bin/bash -e

#Log output
exec > >(tee /var/log/Start-MFDS.log|logger -t user-data -s 2>/dev/console) 2>&1

source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv

export TERM="xterm"
export COBMODE=32

nohup mfds &>/dev/null &
sleep 10
MFDS_COUNT=`COLUMNS=180 ps -eaf | grep -c mfds `
#remove the entry for grep
let MFDS_COUNT-=1
echo "MFDS_COUNT = $MFDS_COUNT"
if ( test $MFDS_COUNT -lt "1")then
    echo "MFDS was not started"
    exit 1
else
    echo "success"
    exit 0
fi

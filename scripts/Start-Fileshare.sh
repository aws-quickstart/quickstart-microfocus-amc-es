#! /bin/bash -e

#Log output
exec > >(tee /var/log/Start-Fileshare.log|logger -t user-data -s 2>/dev/console) 2>&1
export TERM="xterm"
source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv
cd /FSdata
nohup fs -cf /FSdata/fs.conf &>/dev/null &
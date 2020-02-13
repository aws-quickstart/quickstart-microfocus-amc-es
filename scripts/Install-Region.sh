#! /bin/bash -e

#Log output
exec > >(tee /var/log/Install-Region.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 1 ]
then
  echo "Not Enough Arguments supplied."
  echo "Configure-ODBC <path to Region xml>"
  exit 1
fi

RegionXMLPath=$1
export TERM="xterm"
shift
source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv
mfds -g 5 $RegionXMLPath D
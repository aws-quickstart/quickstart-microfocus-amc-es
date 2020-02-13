#! /bin/bash -e

#Log output
exec > >(tee /var/log/Setup-Fileshare.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 1 ]
then
  echo "Not Enough Arguments supplied."
  echo "Setup-Fileshare <FSVIEWUserPassword>"
  exit 1
fi
FSVIEWUserPassword=$1
export TERM="xterm"
shift
source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv

cp -r /home/ec2-user/BankDemo_FS/System/catalog/data/* /FSdata
mkdir /FSdata/PRC
cp -r /home/ec2-user/BankDemo_FS/System/catalog/PRC/* /FSdata/PRC
mkdir /FSdata/CTLCARDS
cp -r /home/ec2-user/BankDemo_FS/System/catalog/CTLCARDS/* /FSdata/CTLCARDS
cp /tmp/fs.conf /FSdata
chmod 777 /FSdata/*
fs -pf /FSdata/pass.dat -u SYSAD -pw SYSAD
fs -pf /FSdata/pass.dat -u FSVIEW -pw $FSVIEWUserPassword

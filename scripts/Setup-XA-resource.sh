#! /bin/bash -e

#Log output
exec > >(tee /var/log/Setup-XA-resource.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 1 ]
then
  echo "Not Enough Arguments supplied."
  echo "Setup-XA-resource <DBMasterPassword>"
  exit 1
fi

DBMasterPassword=$1

sed -i 's/Password123\!/'$DBMasterPassword'/g' /home/ec2-user/BankDemo_SQL/Repo/BNKDMSQL.xml
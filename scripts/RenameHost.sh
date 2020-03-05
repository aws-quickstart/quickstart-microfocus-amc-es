#! /bin/bash -e

#Log output
exec > >(tee /var/log/RenameHost.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 2 ]
then
  echo "Not Enough Arguments supplied."
  echo "RenameHost <Domain> <hostname>"
  exit 1
fi
Domain=$1
hostname=$2

hostnamectl set-hostname $hostname.$Domain
systemctl restart sssd.service

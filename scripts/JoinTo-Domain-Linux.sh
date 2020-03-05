#! /bin/bash -e
######################################################################
# Script to join the instance to an Active Directory domain          #
# Requires the following to already be installed:                    #
# sssd realmd krb5-workstation samba-common-tools                    #
######################################################################

#Log output
exec > >(tee /var/log/JoinTo-Domain-Linux.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 3 ]
then
  echo "Not Enough Arguments supplied."
  echo "JoinTo-Domain-Linux.sh <Join_account> <Domain> <Password>"
  exit 1
fi

Join_account=$1
Domain=$2
Password=$3

# Join the domain
echo $Password | realm join -v -U $Join_account $Domain --install=/

# Allow domain users to logon via passwords
sed -i '/PasswordAuthentication/s/no.*/yes/' /etc/ssh/sshd_config
systemctl restart sshd.service

realm permit Admin@$Domain

#Give domain admins sudo privledges
echo "%AWS\ Delegated\ Administrators@$Domain ALL=(ALL:ALL) ALL" | EDITOR='tee -a' visudo

if [ $? -eq 0 ]; then
    echo "JoinTo-Domain-Linux has passed" >> /var/log/cfn-init.log
    exit 0
else
    echo "JoinTo-Domain-Linux has FAILED" >> /var/log/cfn-init.log
    exit 1
fi
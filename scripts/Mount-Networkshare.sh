#! /bin/bash -e

#Log output
exec > >(tee /var/log/Mount-Networkshare.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install nfs-utils rpcbind -y
echo 'FSSERVER1:/FSdata /DATA nfs rw 0 0' >> /etc/fstab
mkdir /DATA
mount -a
#! /bin/bash -e

#Log output
exec > >(tee /var/log/NetworkShare-Setup.log|logger -t user-data -s 2>/dev/console) 2>&1

mkdir /FSdata/
chmod -R 0777 /FSdata/

systemctl enable nfs-server
systemctl enable rpcbind
systemctl start rpcbind
systemctl start nfs-server
echo '/FSdata *(rw,sync)' >> /etc/exports
exportfs -r
systemctl restart nfs-server
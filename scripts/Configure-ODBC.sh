#! /bin/bash -e

#Log output
exec > >(tee /var/log/Configure-ODBC.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 1 ]
then
  echo "Not Enough Arguments supplied."
  echo "Configure-ODBC <Server>"
  exit 1
fi

Server=$1

cat <<EOT >> /tmp/odbc.ini
[DBNASEDB]
Driver = ODBC Driver 17 for SQL Server
Server = $Server
port = 1433
Database = BANKDEMO
EOT
odbcinst -i -s -l -f /tmp/odbc.ini
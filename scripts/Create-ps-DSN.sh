#! /bin/bash -e

#Log output
exec > >(tee /var/log/Create-ps-DSN.log|logger -t user-data -s 2>/dev/console) 2>&1

if [ "$#" -ne 1 ]
then
  echo "Not Enough Arguments supplied."
  echo "Create-ps-DSN <DBMasterPassword>"
  exit 1
fi

yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql14 postgresql14-odbc
driver=`rpm -ql postgresql14-odbc | grep psqlodbcw.so`

DBMasterPassword=$1
cat <<EOT >> /tmp/odbcinst.ini
[PostgreSQL]
Driver = $driver
EOT
odbcinst -i -d -f /tmp/odbcinst.ini

cat <<EOT >> /tmp/odbc_ps.ini
[PG.POSTGRES]
Driver = PostgreSQL
Servername = ESPACDatabase
port = 5432
Database = postgres
Username = esuser
Password = $DBMasterPassword

[PG.VSAM]
Driver = PostgreSQL
Servername = ESPACDatabase
port = 5432
Database = MicroFocus\$SEE\$Files\$VSAM
Username = esuser
Password = $DBMasterPassword

[PG.REGION]
Driver = PostgreSQL
Servername = ESPACDatabase
port = 5432
Database = MicroFocus\$CAS\$Region\$DEMOPAC
Username = esuser
Password = $DBMasterPassword

[PG.CROSSREGION]
Driver = PostgreSQL
Servername = ESPACDatabase
port = 5432
Database = MicroFocus\$CAS\$CrossRegion
Username = esuser
Password = $DBMasterPassword
EOT
odbcinst -i -s -l -f /tmp/odbc_ps.ini

#! /bin/bash -e

#Log output
exec > >(tee /var/log/deploy.log|logger -t user-data -s 2>/dev/console) 2>&1
export MFDBFH_CONFIG=/home/ec2-user/BankDemo_PAC/System/MFDBFH.cfg
source /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv
dbfhdeploy create sql://ESPACDatabase/VSAM

# deploy catalog into the db
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/CATALOG.DAT sql://ESPACDatabase/VSAM/CATALOG.DAT
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLDSN.dat sql://ESPACDatabase/VSAM/SPLDSN.dat
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLJNO.dat sql://ESPACDatabase/VSAM/SPLJNO.dat?type=seq\;reclen=80,80
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLJOB.dat sql://ESPACDatabase/VSAM/SPLJOB.dat
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLMSG.dat sql://ESPACDatabase/VSAM/SPLMSG.dat
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLOUT.dat sql://ESPACDatabase/VSAM/SPLOUT.dat
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/SPLSUB.dat sql://ESPACDatabase/VSAM/SPLSUB.dat

# deploy data files into the db
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/data/MFI01V.MFIDEMO.BNKACC.DAT sql://ESPACDatabase/VSAM/MFI01V.MFIDEMO.BNKACC.DAT?folder=/DATA
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/data/MFI01V.MFIDEMO.BNKATYPE.DAT sql://ESPACDatabase/VSAM/MFI01V.MFIDEMO.BNKATYPE.DAT?folder=/DATA
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/data/MFI01V.MFIDEMO.BNKCUST.DAT sql://ESPACDatabase/VSAM/MFI01V.MFIDEMO.BNKCUST.DAT?folder=/DATA
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/data/MFI01V.MFIDEMO.BNKHELP.DAT sql://ESPACDatabase/VSAM/MFI01V.MFIDEMO.BNKHELP.DAT?folder=/DATA
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/data/MFI01V.MFIDEMO.BNKTXN.DAT sql://ESPACDatabase/VSAM/MFI01V.MFIDEMO.BNKTXN.DAT?folder=/DATA

# deploy prc files
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/prc/YBATTSO.PRC sql://ESPACDatabase/VSAM/YBATTSO.PRC?folder=/PRC\;type=lseq\;reclen=80,80
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/prc/YBNKEXTV.PRC sql://ESPACDatabase/VSAM/YBNKEXTV.PRC?folder=/PRC\;type=lseq\;reclen=80,80
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/prc/YBNKPRT1.PRC sql://ESPACDatabase/VSAM/YBNKPRT1.PRC?folder=/PRC\;type=lseq\;reclen=80,80
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/prc/YBNKSRT1.PRC sql://ESPACDatabase/VSAM/YBNKSRT1.PRC?folder=/PRC\;type=lseq\;reclen=80,80

# deploy CTL cards
dbfhdeploy -quiet data add /home/ec2-user/BankDemo_PAC/System/catalog/ctlcards/KBNKSRT1.TXT sql://ESPACDatabase/VSAM/KBNKSRT1.TXT?folder=/CTLCARDS\;type=lseq\;reclen=80,80
exit
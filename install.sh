#!/bin/
db_passwd=$1
path=`pwd`;
version=${path##*/}
local_ip=`ss|grep ssh|awk 'NR==1{print $4}'|cut -d \: -f1`
find . -name "*.gz"|xargs -i tar -xf {}
find . -name "config.xml"|xargs -i sed -i "s/192.168.126.132/${local_ip}/g" {}
find . -name "config.xml"|xargs -i sed -i "s/cdn_db/${version}/g" {}
find . -name "config.xml"|xargs -i sed -i "s#suma</db_passwd#123456</${db_passwd}#g" {}
find . -name "*.sql"|grep mysql|xargs -i sed -i "s/cdn_db/${version}/g" {}
mysql -uroot -p"${db_passwd}" -e "drop database ${version};"
for i in `find . -name "*.sql"|grep mysql`;do mysql -uroot -p"${db_passwd}" -e "source ${i};";done
for i in `ls -d */|grep _`;do echo $i;mv $i `echo $i|cut -d _ -f1|tr A-Z a-z`;done 

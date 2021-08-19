#!/bin/bash

## set the parameters***********************

backup_path='/path/backup'
host='localhost'
port='portnumber'
user='root'
passwd='mysecret'
db_name='all_databases'
ip_foreign_ad='10.0.0.1'
foreign_path='/path/scp.gz'
email_target='exemple@exemple.com'
##******************************************************

mkdir -p ${backup_path}

mysqldump -h ${host} -P ${port} -u ${user} -p ${passwd} --all-databases > ${backup_path}/${db_name}_backup.sql



gzip -c ${backup_path}/${db_name}_backup.sql > ${backup_path}/${db_name}_backup.sql.gz


##************************
n=0
while [ $n -lt 50 ]
do
 ((n=n+1))
 ping -c 1 -W 30 $ip_ad
 if [ $? -eq 0 ]
   then 
     echo "Copying the file"
     scp ${backup_path}/${db_name}_backup.sql.gz $ip_ad:$foreign_path
     break
    elif [ $n -eq 50 ]
    then
     echo "sending an email"
     touch email.txt
     echo -e "Subject: Sending email using sendmail\n The @ip $ip_ad is not reacheable" > email.txt
     sendmail $email_target < email.txt 
     
 fi
done

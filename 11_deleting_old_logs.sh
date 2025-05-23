#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"
USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo -e "PLEASE RUN WITH ROOT PRIVILAGES $R sudo sh $0.sh $N"
    exit 1
fi
FILE_DIRECTORY=" /var/log/applogs"
if [ -d $FILE_DIRECTORY ] # HERE -D is used to check the directory exists or not
then
    echo -e "$FILE_DIRECTORY $G Exists...$N"
else
    echo -e "$FILE_DIRECTORY $R NOT Exists...$N"
    exit 1
fi
FILE=$(find $FILE_DIRECTORY -name "*.log" -mtime +14)
echo "$FILE"
while IFS= read -r lin
do
echo -e "$lin $G deleting...$N"
rm -rf $lin
done <<< $FILE

#to create file with particular day touch -d 20240801 java.log
#/home/ec2-user/shell_script/11_deleting_old_logs.sh
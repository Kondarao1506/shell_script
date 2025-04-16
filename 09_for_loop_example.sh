#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[30m"
USERID=$(id -u)
# /var/log/script_logs/filename-timestamp.log we have create this path 
FOLDER_PATH="/var/log/script_logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME=$(date +%Y-%M-%D -%h-%m-%s)
LOG_FILE=$FOLDER_PATH/$SCRIPT_NAME-$TIME.log
mkdir -p $FOLDER_PATH #here p indicates already present or not if present it will not show error.
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 ....FAILED $N" | tee -a $LOG_FILE
    else
         echo -e "$G $2 ....SUCCESS $N" | tee -a $LOG_FILE
    fi
}
USAGE(){
    echo -e "$R USAGE :$N please pass the arguments eg sh $0.sh nginx mysql git" | tee -a $LOG_FILE
}
ROOT(){
 if [ $USERID -ne 0 ]
 then   
    echo -e "$R Please run the command with root priviliges $N" | tee -a $LOG_FILE
}
ROOT
if [ $# -eq 0 ]
then
 USAGE
fi
echo -e "$G Scripting $N execution is started..... $(date)" | tee -a $LOG_FILE
for package in $@
do
dnf list installed $package &>> $LOG_FILE
if [$? -ne 0 ]
then
 echo -e "$R The $package not installed $N...$G going to installing $N" | tee -a $LOG_FILE
 dnf install $package -y &>> $LOG_FILE
 VALIDATE $? "$package installation"
done
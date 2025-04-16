#!/bin/bash
R="\e[m31"
G="\e[m32"
N="\e[m0"
FOLDER_PATH="/var/log/expense_logs/"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%M-%D %H-%M-%S)
LOG_FILE="$FOLDER_PATH/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $FOLDER_PATH
USERID=$(id -u)
ROOT(){
 if [ $USERID -ne 0 ]
 then
  echo -e "$R RUN THE FILE WITH sudo sh $0.sh $N " | tee -a $LOG_FILE
  exit 1
  fi
}
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILED $N " | tee -a $LOG_FILE
    else
        echo -e "$2...$R SUCCESS $N " | tee -a $LOG_FILE
    fi
}
ROOT
echo -e "Scripting has $G started....$N $(date)" | tee -a $LOG_FILE

dnf install nginx -y  &>> $LOG_FILE
VALIDATE $? "NGINX installation"
systemctl enable nginx
 echo -e "NGINX $G Enabled... $N " | tee -a $LOG_FILE
systemctl start nginx
echo -e "NGINX $G started... $N " | tee -a $LOG_FILE
rm -rf /usr/share/nginx/html/*
echo -e "old index files $G removed... $N " | tee -a $LOG_FILE
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $LOG_FILE
echo -e "project files $G downloaded... $N " | tee -a $LOG_FILE
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOG_FILE
echo -e "download files $G Unzipped... $N " | tee -a $LOG_FILE
cp /etc/nginx/default.d/expense.conf #need to set path
systemctl restart nginx
echo -e "NGINX $G Restarted... $N " | tee -a $LOG_FILE
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

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "NODE JS disabled"
dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "NODE JS enabled"
dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Node js installation"
id expense
if [ $? -ne 0 ]
then
    echo -e "$G USER $N adding" | tee -a $LOG_FILE
    useradd expense
else
     echo -e "$G USER $N already added..." | tee -a $LOG_FILE
fi
mkdir -p /app
echo -e "$G app directory created $N" | tee -a $LOG_FILE
rm -rf /tmp/*
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILE
cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>> $LOG_FILE
echo -e "$G App file unziped... $N" | tee -a $LOG_FILE
npm install &>> $LOG_FILE
echo -e "$G Dependencies downloaded $N" | tee -a $LOG_FILE
cp /home/ec2-user/etc/systemd/system/backend.service # need to set path

dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "mysql server installation"
mysql -h 172.31.27.130 -uroot -pExpenseApp@1 < /app/schema/backend.sql # need to set ip address

systemctl daemon-reload
systemctl start backend
systemctl enable backend
systemctl restart backend
echo -e "Bckend .....$G RESTARTED$N" | tee -a $LOG_FILE

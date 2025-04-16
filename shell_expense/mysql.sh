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
  fi
}
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILED $N " | tee -a $LOG_FILE
    else
        echo -e "$2...$R SUCCESS $N " | tee -a $LOG_FILE
}
ROOT
echo -e "Scripting has $G started....$N $(date)" | tee -a $LOG_FILE
dnf list installed mysql-server -y &>> $LOG_FILE
if [$? -ne 0]
then
    echo -e "$R mysql-server $N not installed $G going to installing...$N" | tee -a $LOG_FILE
    dnf install mysql-server -y &>> $LOG_FILE
    VALIDATE $? "mysql-server installation" 
else
    echo -e "mysql-server $G already installed... $N" | tee -a $LOG_FILE
fi
systemctl enable mysqld &>> $LOG_FILE 
VALIDATE $? "mysql-server enabled"

systemctl start mysqld &>> $LOG_FILE
VALIDATE $? "mysql-server started"

mysql -h 172.31.27.130 -u root -pExpenseApp@1 -e 'show databases'  &>> $LOG_FILE  #change host adress acording to server   
if [ $? -ne 0 ]
then
    echo -e "$G setting mysql server password...$N" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $LOG_FILE
else
    echo -e "$G Already mysql server password setting completed...$N" | tee -a $LOG_FILE
fi

#!bin/bash
LOG_DIR="/var/log/applogs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOG_DIR/$SCRIPT_NAME-$TIME.log"
mkdir -p $LOG_DIR
USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "PLEASE RUN WITH ROOT PRIVILAGES sudo sh $0.sh" | tee -a $LOG_FILE
    exit 1
fi
for i in {1..10}
do
if [ $i -eq 1 ]
then
echo "creating log files"
fi
logs=$(touch -d $TIME JAVA$i.log)&>>$LOG_FILE
echo "$logs"
done
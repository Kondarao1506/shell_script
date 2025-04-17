#!/bin/bash
#/home/ec2-user/shell_script/11_deleting_old_logs.sh
#source file /var/log/sourcefilelogs   dest /var/log/destifilelogs
SOUR_FILE=$1
DEST_FILE=$2
DAYS=${3: -14} # it is optional value if we not pass 3rd value it will take 14 by default
TIME=$(date +%Y-%m-%d-%H-%M-%S)
USAGE()
{
    echo "PLEASE PASS THE ARGUMENTS SOURCE AND DESTINATION DAYS(OPTIONAL)"
    exit 1
}
if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOUR_FILE ]
then
    echo "SOURCE directory not exists..."
    exit 1
fi

if [ ! -d $DEST_FILE ]
then
    echo "DESTINATION directory not exists..."
    exit 1
fi

FILE=$(find $SOUR_FILE -name "*.log" -mtime +$DAYS)

if [ ! -z $FILE ]
then
    echo "files found"
    ZIPFILE="$DEST_FILE/applogs-$TIME.zip"
    dnf install zip -y
    find $SOUR_FILE -name "*.log" -mtime +$DAYS | zip $ZIPFILE @
    while IFS= read -r filee
    do
    rm -rf $filee
    done <<< $FILE

else
    echo "files not found for more than $DAYS"
fi
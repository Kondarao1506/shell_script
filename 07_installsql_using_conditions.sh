#!/bin/bash
#algorithm
#check root user or not
#if not exit from execution
#else continue the execution 
#sql installed or not check
#if installed msg to user installed 
#else not installed

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "not root user please continue with root user"
    exit 1
else
    dnf list installed mysql
    if [ $? -ne 0 ] #$? here it is used for checking previous cmd success or not if not 1 to 127 any number it will show else succes =0 
    then
        dnf install mysql
        if [ $? -ne 0 ]
        then
            echo "my sql installation not succes"
        fi
    else
        echo "Alredy installed"
    fi
fi
#!/bin/bash
# install nginx
#install mysql using functions and colours
#dnf install nginx -y
#dnf install mysql -y
g="\e[32m"
r="\e[31m"
n="\e[0m"
root(){ #root user function
if [ $userid -ne 0 ]
then
 echo -e "$r You are not root user run with sudo $n"
 exit 1
fi
}
validate(){
    if [ $1 -eq 0 ]
    then
     echo -e "$g $2 SUCESS... $n"
    else
     echo -e "$g $2 Failed... $n"
    fi
    }
userid=$(id -u)
root #checking root user function
dnf list installed nginx
if [ $? -ne 0 ]
then
    echo "Nginx is going to installing"
    dnf install nginx -y
    validate $? "nginx installation!"
else
    echo -e " $g Nginx is already installed"
fi

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "Mysql is going to installing"
    dnf install mysql -y
    validate $? "mysql installation!"
else
    echo -e " $g mysql is already installed"
fi



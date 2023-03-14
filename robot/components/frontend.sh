#!/bin/bash
echo "I am Frontend"
COMPONENT=frontend
LogFile=/tmp/$COMPONENT.log

set -e
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m you need to be root user to execute this command or prefix sudo before the command \e[0m"
    exit 1

fi 

stat() {
    if [ $1 -eq 0 ] ; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
        exit 2
    fi 
}

echo -n "Installing the Nginx:"  
yum install nginx -y &>> $LogFile
stat $?





echo -n "Dowloading the $COMPONENT compoment:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

stat $?
echo -n "Performing the cleanup of old $COMPONENT component:"
cd /usr/share/nginx/html
rm -rf *  &>> $LogFile
stat $?

echo -n "copying the downloaded $COMPONENT content:"
unzip /tmp/$COMPONENT.zip &>> /tmp/$COMPONENT.log

stat $?

mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "Starting the service:"

systemctl daemon-reload
systemctl enable nginx &>> $LogFile
systemctl restart nginx &>> $LogFile
stat $?




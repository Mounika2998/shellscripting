#!/bin/bash
echo "I am mysql"
COMPONENT=mysql
source components/common.sh #source is going to load the file, so that u can call all of them

echo -n "Configuring the $COMPONENT repo:"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LogFile
stat $?

echo -n "Installing the $COMPONENT:"
yum install mysql-community-server -y &>> $LogFile
stat $?

echo -n "Starting $COMPONENT :"
systemctl enable mysqld  &>> $LogFile
systemctl start mysqld   &>> $LogFile
stat $?


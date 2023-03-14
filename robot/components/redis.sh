#!/bin/bash
echo "I am redis"
COMPONENT=redis
LogFile=/tmp/$COMPONENT.log



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
echo -n "Configuring the $COMPONENT repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing the $COMPONENT server:"
yum install redis-6.2.11 -y &>> $LogFile
stat $?

echo -n "Updating the $COMPONENT visibility : "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf
stat $? 

echo -n "Performing Daemon-Reload : "
systemctl daemon-reload  
systemctl enable $COMPONENT &>> $LogFile
systemctl restart $COMPONENT
stat $?
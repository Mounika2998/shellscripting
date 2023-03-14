#!/bin/bash
echo "I am redis"
COMPONENT=redis
source components/common.sh
echo -n "Configuring the $COMPONENT repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>> $LogFile
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
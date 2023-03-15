#!/bin/bash 

# set -e 

COMPONENT=rabbitmq
source components/common.sh 

echo -n "Installing and Configuring Dependency :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash   &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $? 

echo -n "Installing $COMPONENT :"
yum install rabbitmq-server -y  &>> $LOGFILE 
stat $? 

echo -n "Starting $COMPONENT :"
systemctl enable rabbitmq-server  &>> $LOGFILE 
systemctl start rabbitmq-server   &>> $LOGFILE 
stat $?

rabbitmqctl list_users | grep $APPUSER  &>> $LOGFILE 
if [ $? -ne 0 ] ; then 
    echo -n "Creating $COMPONENT Application User :"
    rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE 
    stat $?
fi 

echo -n "Adding required privileges to the $APPUSER :"
rabbitmqctl set_user_tags roboshop administrator           &>> $LOGFILE 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> $LOGFILE 
stat $? 
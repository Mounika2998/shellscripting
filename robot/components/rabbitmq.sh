#!/bin/bash
echo "I am rabbitmq"
COMPONENT=rabbitmq

source components/common.sh 
echo -n "Installing and Configuring the Depencdency:"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh |  bash &>> $LogFile
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh |  bash &>> $LogFile
stat $?

echo -n "Installing $COMPONENT server:"
yum install rabbitmq-server -y &>> $LogFile
stat $?

echo -n "Starting the $COMPONENT :"
systemctl enable $COMPONENT-server &>> $LogFile
systemctl start $COMPONENT-server
stat $?

rabbitmqctl list_users | grep $APPUSER &>> $LogFile
if [ $? -ne 0 ] ; then 
    echo -n "Creating $COMPONENT Application User: "
    rabbitmqctl add_user roboshop roboshop123 &>> $LogFile
    stat $?
fi

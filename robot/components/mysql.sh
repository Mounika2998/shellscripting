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

echo -n "Grab the default password:"
DEFAULT_ROOT_PWD=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
stat $?

#This should execute only for the first time or wjen the default password is not changed
echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $LogFile
if [ $? -ne 0 ] ; then
    echo -n "Password reset of root user :"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PWD}" &>> $LogFile
    stat $?
fi

echo -n "Uninstalling the password validation plugin"
echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1 &>> $LogFile
stat $?

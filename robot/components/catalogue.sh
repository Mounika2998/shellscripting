#!/bin/bash
echo "I am catalogue"
COMPONENT=catalogue
LogFile=/tmp/$COMPONENT.log
APPUSER=roboshop

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
echo -n "Configuring the repo:"
curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -  &>> $LogFile
stat $?

echo -n "Installing  Nginx:"
yum install nodejs -y  &>> $LogFile
stat $? 

id $APPUSER &>> $LogFile
if [ $? -ne 0 ] ; then 
    echo -n "creating the Application user account:"
    useradd $APPUSER 
fi


echo -n "Downloading the $COMPONENT component:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LogFile
stat $? 

echo -n "Extracting the $COMPONENT in the $APPUSER directory"
cd /home/$APPUSER
rm -rf /home/$APPUSER/$COMPONENT
unzip -o /tmp/$COMPONENT.zip &>> $LogFile
stat $?

echo -n "Configuring the permissions:"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

echo -n "Installing the $COMPONENT Application:"
cd /home/$APPUSER/$COMPONENT/ 
npm install &>> $LogFile
stat $?
echo -n "Updating the systemd file with DB details:"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
 mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting the $COMPONENT service :"
systemctl daemon-reload
systemctl restart $COMPONENT
systemctl enable $COMPONENT &>> $LogFile
stat $?










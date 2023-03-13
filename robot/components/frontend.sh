#!/bin/bash
echo "I am Frontend"

set -e
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m you need to be root user to execute this command or prefix sudo before the command \e[0m"
    exit 1

fi  
echo -n "Installing the Nginx:"  
yum install nginx -y &>> /tmp/frontend

if [ $? -eq 0 ] ; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
        exit 2
fi 



echo -n "Dowloading the frontend compoment:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

if[ $? -eq 0 ] ; then
        echo -e "\e[32m Sucess \e[0m"
    else
        echo -e "\e[31m failure \e[0m"
        exit 2

fi
echo -n "Performing the cleanup of old frontend component:"
cd /usr/share/nginx/html
rm -rf *  &>> /tmp/frontend

if[ $? -eq 0 ] ; then
    echo -e "\e[32m Sucess \e[0m"
else
    echo -e "\e[31m failure \e[0m"
    exit 2

fi

echo -n "copying the downloaded frontend content:"
unzip /tmp/frontend.zip &>> /tmp/frontend
if[ $? -eq 0 ] ; then
    echo -e "\e[32m Sucess \e[0m"
else
    echo -e "\e[31m failure \e[0m"
    exit 2

fi
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> /tmp/frontend
systemctl restart nginx &>> /tmp/frontend




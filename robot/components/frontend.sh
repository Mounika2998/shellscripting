#!/bin/bash
echo "I am Frontend"

set -e
ID=$(id -u)

if["$ID" -ne 0]; then
    echo -e "\e[31m you need to be root user to execute this command or prefix sudo before the command \e[0m"
    exit 1
yum install nginx -y

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf * &>> /tmp/frontend
unzip /tmp/frontend.zip &>> /tmp/frontend
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> /tmp/frontend
systemctl restart nginx &>> /tmp/frontend




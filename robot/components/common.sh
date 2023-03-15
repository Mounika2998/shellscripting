LogFile=/tmp/$COMPONENT.log
APPUSER=roboshop

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
CREATE_USER()
{
    id $APPUSER &>> $LogFile
    if [ $? -ne 0 ] ; then 
        echo -n "creating the Application user account:"
        useradd $APPUSER 
    fi
}
DOWNLOAD_AND_EXTRACT()
{
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
}

NPM_INSTALL()
{
    echo -n "Installing the $COMPONENT Application:"
    cd /home/$APPUSER/$COMPONENT/ 
    npm install &>> $LogFile
    stat $?
}

CONFIG_SVC()
{
    echo -n "Updating the systemd file with DB details:"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/'  -e  's/CARTHOST/cart.roboshop.internal/' -e  's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $? 

    echo -n "Starting the $COMPONENT service : "
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?

}

MVN_PACKAGE() {
    echo -n "Creating the $COMPONENT Package :"
    cd /home/$APPUSER/$COMPONENT/ 
    mvn clean package  &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?   
}

PYTHON() {
    echo -n "Installing Python and dependencies :"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    echo -n "Installing $COMPONENT :"
    cd /home/roboshop/$COMPONENT/ 
    pip3 install -r requirements.txt   &>> $LOGFILE 
    stat $? 

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    
    echo -n "Updating the $COMPONENT.ini file :"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini 

    # Calling Config-Svc Function
    CONFIG_SVC

}

JAVA() {
    echo -n "Installing Maven  :" 
    yum install maven -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling Maven Package Functon
    MVN_PACKAGE

    # Calling Config-Svc Function
    CONFIG_SVC

}






NODEJS() {

    echo -n "Configuring the nodejs repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>> $LOGFILE
    stat $?  

    echo -n "Installing NodeJS :"
    yum install nodejs -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling NPM Install Function
    NPM_INSTALL

    # Calling Config-Svc Function
    CONFIG_SVC

}

    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "Starting the $COMPONENT service :"
    systemctl daemon-reload
    systemctl enable $COMPONENT &>> $LogFile
    systemctl restart $COMPONENT

    stat $?
}

MVN_PACKAGE()
{
    echo -n "Creating the $COMPONENT package:"
    cd /home/$APPUSER/$COMPONENT/ 
    mvn clean package &>> $LogFile
    mv target/shipping-1.0.jar shipping.jar

    stat $?


}

PYTHON()
{

    echo -n "INstalling python and its dependencies:"
    yum install python36 gcc python3-devel -y &>> $LogFile
    stat $?
    #Calling the CREATE_USER function
    CREATE_USER
    #Calling the DOWNLOAD_AND_EXTRACT function
    DOWNLOAD_AND_EXTRACT
    echo -n "Installing the $COMPONENT:"
    cd /home/$APPUSER/$COMPONENT
    pip3 install -r requirements.txt &>> $LogFile
    stat $?
    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    
    echo -n "Updating the $COMPONENT.ini file :"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini 
    stat $?
    # Calling Config-Svc Function
    CONFIG_SVC

} 


JAVA()
{
    echo -n "Installing maven :"
    yum install maven -y &>> $LogFile
    stat $?
    #Calling the CREATE_USER function
    CREATE_USER
    #Calling the DOWNLOAD_AND_EXTRACT function
    DOWNLOAD_AND_EXTRACT
    #Calling the Maven Package
    MVN_PACKAGE
    #Calling the CONFIG_SVC function
    CONFIG_SVC

    
}

NODEJS() {

    echo -n "Configuring the repo:"
    curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -  &>> $LogFile
    stat $?
    echo -n "Installing  Nodejs:"
    yum install nodejs -y  &>> $LogFile
    stat $? 
    #Calling the CREATE_USER function
    CREATE_USER
    #Calling the DOWNLOAD_AND_EXTRACT function
    DOWNLOAD_AND_EXTRACT
    #Calling the NPM_INSTALL function
    NPM_INSTALL
    #Calling the CONFIG_SVC function
    CONFIG_SVC


}
#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB Password:"
read -s mysql_root_password

dnf install maven -y &>>$LOGFILE
VALIDATE $? "Installing maven"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "Downloading shipping code"

unzip /tmp/shipping.zip &>>$LOGFILE
VALIDATE $? "Extracting the shipping code"

mvn clean package &>>$LOGFILE
VALIDATE $? "Cleaning the packages"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE
VALIDATE $? "Shipping jar file"

cp /home/ec2-user/roboshop-shell/api-tier/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE
VALIDATE $? "Copied shipping service"

systemctl enable shipping &>>$LOGFILE
VALIDATE $? "Enabling shipping"

systemctl start shipping &>>$LOGFILE
VALIDATE $? "Starting shipping"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL"

mysql -h mysql.neelareddy.store -uroot -p${mysql_root_password} < /app/schema/shipping.sql 
VALIDATE $? "Schema loading"

systemctl restart shipping &>>$LOGFILE
VALIDATE $? "Restarting shipping"

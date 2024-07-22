#!/bin/bash

source ./common.sh

check_root

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
VALIDATE $? "Downloading catalogue code"

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "Extracting the catalogue code"

cp /home/ec2-user/roboshop-shell/api-tier/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
VALIDATE $? "Copied catalogue service"

systemctl enable catalogue &>>$LOGFILE
VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>>$LOGFILE
VALIDATE $? "Starting catalogue"

cp /home/ec2-user/roboshop-shell/api-tier/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Setup mongoDB repo"

dnf install -y mongodb-mongosh &>>$LOGFILE
VALIDATE $? "Install mongodb-client"

mongosh --host mongodb.neelareddy.store </app/schema/catalogue.js &>>$LOGFILE
VALIDATE $? "Schema loading"
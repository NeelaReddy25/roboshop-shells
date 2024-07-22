#!/bin/bash

source ./common.sh

check_root

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE
VALIDATE $? "Downloading user code"

cd /app 
rm -rf /app/*
unzip /tmp/user.zip &>>$LOGFILE
VALIDATE $? "Extracting the user code"

cp /home/ec2-user/roboshop-shell/api-tier/user.service /etc/systemd/system/user.service &>>$LOGFILE
VALIDATE $? "Copied user service"

systemctl enable user &>>$LOGFILE
VALIDATE $? "Enabling user"

systemctl start user &>>$LOGFILE
VALIDATE $? "Starting user"

cp /home/ec2-user/roboshop-shell/api-tier/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Setup mongoDB repo"

dnf install -y mongodb-mongosh &>>$LOGFILE
VALIDATE $? "Install mongodb-client"

mongosh --host mongodb.neelareddy.store </app/schema/user.js &>>$LOGFILE
VALIDATE $? "Schema loading"

#!/bin/bash

source ./common.sh

check_root

# Setup the MongoDB repo file
cp /home/ec2-user/roboshop-shell/db-tier/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Setup mongoDB repo"

dnf install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installing mongoDB org"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabling mongod"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "Starting mongod"

cp /home/ec2-user/roboshop-shell/db-tier/mongod.conf /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "Update listen address"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "Restarting mongod"

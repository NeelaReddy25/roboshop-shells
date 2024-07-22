#!/bin/bash

source ./common.sh

check_root

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
VALIDATE $? "Downloading cart code"

unzip /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "Extracting the cart code"

cp /home/ec2-user/roboshop-shell/api-tier/cart.service /etc/systemd/system/cart.service &>>$LOGFILE
VALIDATE $? "Copied cart service"

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

systemctl enable cart &>>$LOGFILE
VALIDATE $? "Enabling cart"

systemctl start cart &>>$LOGFILE
VALIDATE $? "Starting cart"
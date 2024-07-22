#!/bin/bash

source ./common.sh

check_root

dnf install python36 gcc python3-devel -y &>>$LOGFILE
VALIDATE $? "Installing python"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE
VALIDATE $? "Downloading payment code"

unzip /tmp/payment.zip &>>$LOGFILE
VALIDATE $? "Extracting the payment code"

pip3.6 install -r requirements.txt &>>$LOGFILE
VALIDATE $? "Installing python requirements"

cp /home/ec2-user/roboshop-shell/api-tier/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
VALIDATE $? "Copied payment service"

systemctl enable payment &>>$LOGFILE
VALIDATE $? "Enabling payment"

systemctl start payment &>>$LOGFILE
VALIDATE $? "Starting payment"

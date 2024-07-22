#!/bin/bash

source ./common.sh

check_root

dnf install redis -y &>>$LOGFILE
VALIDATE $? "Installing redis"

systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enabling redis"

systemctl start redis &>>$LOGFILE
VALIDATE $? "Starting redis"

cp /home/ec2-user/roboshop-shell/db-tier/redis.conf /etc/redis/redis.conf &>>$LOGFILE
VALIDATE $? "Update listen address"

systemctl restart redis &>>$LOGFILE
VALIDATE $? "Restarting redis"
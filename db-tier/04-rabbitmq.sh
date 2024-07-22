#!/bin/bash

source ./common.sh

check_root

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "Downloading the rabbitmq"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "Installing packages rabbitmq"

dnf install rabbitmq-server -y  &>>$LOGFILE
VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>>$LOGFILE
VALIDATE $? "Enabling rabbitmq server"

systemctl start rabbitmq-server &>>$LOGFILE
VALIDATE $? "Starting rabbitmq server"

if [ $? -ne 0 ]
then
    rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
    VALIDATE $? "Creating roboshop user"
else
    echo -e "rabbitmqctl add_user roboshop roboshop123...$Y SKIPPING $N"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? "Setting permissions rabbitmq"

#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
instances=("mongodb" "redis" "web")
domain_name="neelareddy.store"
hosted_zone_id="Z001712433NLPH2AI8HH5"

VALIDATE(){
    if [ $1 -ne 0 ] 
    then
        echo -e "$2...$R FAILURE $N"
        exit1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

# if [ $USERID -ne 0 ]
# then
#     echo "Please run this script with root access."
#     exit1 # manually exit if error comes.
# else
#     echo "You are super user."
# fi


for name in ${instances[@]}; do
    if [ $name == "mongodb" ] 
    then
        instance_type="t3.medium"
    else
        instance_type="t3.micro"
    fi
    echo "Creating instance for: $name with instance type: $instance_type"
    instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --instance-type $instance_type --security-group-ids sg-0cd5626364cf1e071 --subnet-id subnet-045b66b79d1f5cc3f --query 'Instances[0].InstanceId' --output text) &>>$LOGFILE
    VALIDATE $? "Creating instances"
    echo "Instance created for: $name"

    aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name &>>$LOGFILE
    VALIDATE $? "Creating tags"

    if [ $name == "web" ]
    then
        aws ec2 wait instance-running --instance-ids $instance_id &>>$LOGFILE
        VALIDATE $? "Waiting instances"
        public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PublicIpAddress]' --output text) &>>$LOGFILE
        VALIDATE $? "Describe instances"
        ip_to_use=$public_ip
    else
        private_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PrivateIpAddress]' --output text) &>>$LOGFILE
        VALIDATE $? "Describe instances"
        ip_to_use=$private_ip
    fi

    echo "Creating R53 record for: $name"
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch ' 
    {
        "Comment": "Creating a record set for '$name'"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$name.$domain_name'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$ip_to_use'"
            }]
        }
        }]
    }'

done
#!/bin/bash

source ./create-ec2.sh
instances=("mongodb" "redis" "web")

for name ${instances[@]}; do 
    echo "Creating instance for: $name
    aws ec2 terminate-instances --instance-ids $instance_id
done  


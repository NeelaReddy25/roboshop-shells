#!/bin/bash

INSTANCE_ID="source ./create-ec2.sh"

aws ec2 terminate-instances --instance-ids "$INSTANCE_ID"
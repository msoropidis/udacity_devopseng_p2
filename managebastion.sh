#!/bin/bash

basstack="udagrambst"
bastemplate="file://udagram-bastion.yml"
basparameters="file://udagram-bastion-param.json"
region="eu-west-1"
myip="`curl -s ifconfig.co/ip`/32"
EnvName="udagram"
Mykey="testkey"

echo -e "\
Script to manage the server and stack
!!! Note: script does not use the template parameters !!!

current IP: $myip

Select option:
1 ) Crate bastion server stack.
2 ) Update source IP for SSH (Use in case your IP has changed)
3 ) Delete bastion server stack.
4 ) Do nothing and exit and show Public IP if it exists.
"

read -p "Enter selection: " sbaction

case $sbaction in

    1 )     aws cloudformation create-stack --stack-name $basstack --template-body $bastemplate --parameters ParameterKey=EnvName,ParameterValue=Udagram ParameterKey=MyKey,ParameterValue=udatest ParameterKey=SourceIP,ParameterValue=$myip --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region
            echo "Waiting for bastion server to be created."
            aws cloudformation wait stack-create-complete --stack-name $basstack
            echo "Bastion server created."
            pubip=`aws cloudformation describe-stacks --stack-name $basstack --query "Stacks[0].Outputs[?OutputKey=='PUBIPBastionSRV'].OutputValue" --output text`
            echo -e "The public ip of the server is:\n\n$pubip\n"
            ;;
    2 )     aws cloudformation update-stack --stack-name $basstack --template-body $bastemplate --parameters ParameterKey=EnvName,ParameterValue=Udagram ParameterKey=MyKey,ParameterValue=udatest ParameterKey=SourceIP,ParameterValue=$myip --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region
            echo "Waiting for bastion server to be updated."
            aws cloudformation wait stack-update-complete --stack-name $basstack
            echo "Bastion server updated."
            ;;
    3 )     aws cloudformation delete-stack --stack-name $basstack
            echo "Waiting for bastion server to be deleted."
            aws cloudformation wait stack-delete-complete --stack-name $basstack
            echo "Bastion server deleted."
            ;;
    4 )     pubip=`aws cloudformation describe-stacks --stack-name $basstack --query "Stacks[0].Outputs[?OutputKey=='PUBIPBastionSRV'].OutputValue" --output text`
            echo -e "The public ip of the server is:\n\n$pubip\n"
            echo "Exiting script."
            exit 0
            ;;
esac
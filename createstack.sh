#!/bin/bash

infrastack="udagraminfra"
infratemplate="file://udagram-net-infra.yml"
infraparameters="file://udagram-net-infra-param.json"
srvstack="udagramsrv"
srvtemplate="file://udagram-srv.yml"
srvparameters="file://udagram-srv-param.json"
region="eu-west-1"

echo "
Select which stack to create:

1) Infrastructure stack.
2) Server stack.
3) Exit.
"
read -p "Enter selection: " crtaction

case $crtaction in
    1 ) aws cloudformation create-stack --stack-name $infrastack --template-body $infratemplate --parameters $infraparameters --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region --output text
        echo "Wait till completion message"
        aws cloudformation wait stack-create-complete --stack-name $infrastack
        echo "Create job completed. Checking status."
        aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text | grep "$infrastack"
        ;;
    2 ) aws cloudformation create-stack --stack-name $srvstack --template-body $srvtemplate --parameters $srvparameters --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region --output text
        echo "Wait till completion message"
        aws cloudformation wait stack-create-complete --stack-name $srvstack
        echo "Create job completed. Checking status."
        aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text | grep "$srvstack"
        URL=`aws cloudformation describe-stacks --stack-name $srvstack --query "Stacks[0].Outputs[?OutputKey=='WebAppLBDNSName'].OutputValue" --output text`
        echo -e "Application is available in the following URL:\n\n$URL\n"
        ;;
    3 ) exit 0
        ;;
esac
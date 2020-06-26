#!/bin/bash

infrastack="udagraminfra"
infratemplate="file://udagram-net-infra.yml"
infraparameters="file://udagram-net-infra-param.json"
srvstack="udagramsrv"
srvtemplate="file://udagram-srv.yml"
srvparameters="file://udagram-srv-param.json"
region="eu-west-1"

echo "
Select which stack to update:

1) Infrastructure stack.
2) Server stack.
3) Show application URL
4) Exit.
"
read -p "Enter selection: " updaction

case $updaction in

    1 ) aws cloudformation update-stack --stack-name $infrastack --template-body $infratemplate --parameters $infraparameters --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region --output text
        echo "Wait till completion message"
        aws cloudformation wait stack-update-complete --stack-name $infrastack
        echo "Update job completed. Checking status"
        aws cloudformation list-stacks --stack-status-filter UPDATE_COMPLETE --output text | grep "$infrastack"
        ;;
    2 ) aws cloudformation update-stack --stack-name $srvstack --template-body $infratemplate --parameters $infraparameters --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region=$region --output text
        echo "Wait till completion message"
        aws cloudformation wait stack-update-complete --stack-name $srvstack
        echo "Update job completed. Checking status"
        aws cloudformation list-stacks --stack-status-filter UPDATE_COMPLETE --output text | grep "$srvstack"
        URL=`aws cloudformation describe-stacks --stack-name $srvstack --query "Stacks[0].Outputs[?OutputKey=='WebAppLBDNSName'].OutputValue" --output text`
        echo -e "Application is available in the following URL:\n\n$URL\n"
        ;;
    3 ) URL=`aws cloudformation describe-stacks --stack-name $srvstack --query "Stacks[0].Outputs[?OutputKey=='WebAppLBDNSName'].OutputValue" --output text`
        echo -e "Application is available in the following URL:\n\n$URL\n"
        ;;
    4 ) exit 0
esac


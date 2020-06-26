#!/bin/bash

infrastack="udagraminfra"
srvstack="udagramsrv"

echo "
Select which stack to delete:

1) Infrastructure stack.
2) Server stack.
3) All.
4) Exit.
"
read -p "Enter selection: " delaction

case $delaction in
    1 ) aws cloudformation delete-stack --stack-name $srvstack 
        echo "Deleting server stack $srvstack"
        aws cloudformation wait stack-delete-complete --stack-name $srvstack
        echo "Server stack $srvstack has been deleted"
        ;;
    2 ) aws cloudformation delete-stack --stack-name $infrastack
        echo "Deleting server stack $infrastack"
        aws cloudformation wait stack-delete-complete --stack-name $infrastack
        echo "Infrastructure stack $infrastack has been deleted"
        ;;
    3 ) aws cloudformation delete-stack --stack-name $srvstack 
        echo "Deleting server stack $srvstack"
        aws cloudformation wait stack-delete-complete --stack-name $srvstack
        echo "Server stack $srvstack has been deleted"
        aws cloudformation delete-stack --stack-name $infrastack
        echo "Deleting server stack $infrastack"
        aws cloudformation wait stack-delete-complete --stack-name $infrastack
        echo "Infrastructure stack $infrastack has been deleted"
        ;;
    4 ) exit 0
esac

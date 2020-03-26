#!/bin/bash

shopt -s failglob
set -eu -o pipefail

echo "Checking if stack exists ..."
if !(aws cloudformation describe-stacks --region $1 --stack-name $2); then

    echo -e "\nStack does not exist, creating ..."
    aws cloudformation create-stack \
        --region=$1 \
        --stack-name $2 \
        --template-body file://$3 \
        --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
        ${@:4}

    echo "Waiting for stack to be created ..."
    aws cloudformation wait stack-create-complete \
        --region $1 \
        --stack-name $2

else

    echo -e "\nStack exists, attempting update ..."

    set +e
    update_output=$(\
        aws cloudformation update-stack \
            --region=$1 \
            --stack-name $2 \
            --template-body file://$3 \
            --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
            ${@:4} 2>&1)
    status=$?
    set -e

    echo "$update_output"

    if [ $status -ne 0 ]; then
        # Don't fail for no-op update
        if [[ $update_output == *"ValidationError"* && $update_output == *"No updates"* ]]; then
            echo -e "\nFinished create/update - no updates to be performed"
            exit 0
        else
            exit $status
        fi
    fi

    echo "Waiting for stack update to complete ..."
    aws cloudformation wait stack-update-complete \
        --region $1 \
        --stack-name $2

fi

echo "Finished create/update."
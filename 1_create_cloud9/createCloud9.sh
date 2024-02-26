#!/bin/bash
STACKNAME="eks-handson-cloud9"
CLOUD9_OWNER_ARN=$(aws sts get-caller-identity --query 'Arn' --output text)
TAG_NAME="eks-handson-cloud9"

aws cloudformation deploy --template-file cloud9_template.yaml \
  --stack-name "${STACKNAME}" \
  --parameter-overrides Cloud9OwnerArn="${CLOUD9_OWNER_ARN}" TagName="${TAG_NAME}"

#!/bin/bash
STACKNAME="eks-handson-cloud9"
CLOUD9_OWNER_ARN=$(aws sts get-caller-identity --query 'Arn' --output text)
TAG_NAME="eks-handson-cloud9"

aws iam create-role --role-name AWSCloud9SSMAccessRole --path /service-role/ --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Principal": {"Service": ["ec2.amazonaws.com","cloud9.amazonaws.com"]},"Action": "sts:AssumeRole"}]}'
aws cloudformation deploy --template-file cloud9_template.yaml \
  --stack-name "${STACKNAME}" \
  --parameter-overrides Cloud9OwnerArn="${CLOUD9_OWNER_ARN}" TagName="${TAG_NAME}"

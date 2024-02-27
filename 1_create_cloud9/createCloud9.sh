#!/bin/bash
STACKNAME="eks-handson-cloud9"
CLOUD9_OWNER_ARN=$(aws sts get-caller-identity --query 'Arn' --output text)
TAG_NAME="eks-handson-cloud9"

# setup service role and instance profile for first deploy account.
if [ -z "$(aws iam list-roles --query 'Roles[?RoleName==`AWSCloud9SSMAccessRole`].RoleName' --output text)" ];then
  aws iam create-role --role-name AWSCloud9SSMAccessRole --path /service-role/ --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Principal": {"Service": ["ec2.amazonaws.com","cloud9.amazonaws.com"]},"Action": "sts:AssumeRole"}]}'
  aws iam attach-role-policy --role-name AWSCloud9SSMAccessRole --policy-arn arn:aws:iam::aws:policy/AWSCloud9SSMInstanceProfile
fi

if [ -z "$(aws iam list-instance-profiles --query 'InstanceProfiles[?InstanceProfileName==`AWSCloud9SSMInstanceProfile`].InstanceProfileName' --output text)" ];then
  aws iam create-instance-profile --instance-profile-name AWSCloud9SSMInstanceProfile --path /cloud9/
  aws iam add-role-to-instance-profile --instance-profile-name AWSCloud9SSMInstanceProfile --role-name AWSCloud9SSMAccessRole
fi

# Cloud Formation deploy
aws cloudformation deploy --template-file cloud9_template.yaml \
  --stack-name "${STACKNAME}" \
  --parameter-overrides Cloud9OwnerArn="${CLOUD9_OWNER_ARN}" TagName="${TAG_NAME}"

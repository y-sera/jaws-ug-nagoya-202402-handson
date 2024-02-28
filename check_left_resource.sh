#!/bin/bash

# Check ELB
echo "[INFO] Check ELB[MAX:5]" 
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-argocd`)].[LoadBalancerName]' --output text
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-apps`)].[LoadBalancerName]' --output text
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-webhook`)].[LoadBalancerName]' --output text
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-chartmuseum`)].[LoadBalancerName]' --output text
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-dashboard`)].[LoadBalancerName]' --output text
echo ""
echo "-----------"

# Check CLoudFormation Stack
echo "[INFO] Check CloudFormation Stack[MAX:2]"
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && StackName==`TektonDemoInfra`)].StackName' --output text
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && StackName==`TektonDemoBuckets`)].StackName' --output text
echo ""
echo "-----------"

echo "[INFO] Check CloudFormation Stack(ServiceAccounts)[MAX:4]"
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `chartmuseum-sa`))].StackName' --output text
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `pipeline-sa`))].StackName' --output text
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `ebs-csi-controller-sa`))].StackName' --output text
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `aws-load-balancer-controller`))].StackName' --output text
echo ""
echo "-----------"

echo "[INFO] Check CloudFormation Stack(EKS cluster)[MAX:2]"
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `eksctl-eks-handson-cluster-nodegroup-worker-ng`))].StackName' --output text
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `eksctl-eks-handson-cluster-cluster`))].StackName' --output text
echo ""
echo "-----------"

echo "[INFO] Check CloudFormation Stack(cloud9)[MAX:1]"
aws cloudformation list-stacks --query 'StackSummaries[?(StackStatus!=`DELETE_COMPLETE` && contains(StackName, `aws-cloud9-eks-handson`))].StackName' --output text
echo ""
echo "-----------"

# Check ECR
echo "[INFO] Check ECR[MAX:3]"
aws ecr describe-repositories --query 'repositories[?repositoryName==`maven-builder`].repositoryName' --output text
aws ecr describe-repositories --query 'repositories[?repositoryName==`tekton-demo-app`].repositoryName' --output text
aws ecr describe-repositories --query 'repositories[?repositoryName==`cloner`].repositoryName' --output text
echo ""
echo "-----------"

# Check Artifact
echo "[INFO] Check Artifact[MAX:2]"
aws codeartifact list-repositories --query 'repositories[?name==`maven-central-store`].name' --output text
aws codeartifact list-repositories --query 'repositories[?name==`tekton-demo-repository`].name' --output text
echo ""
echo "-----------"

# Check S3
echo "[INFO] Check S3[MAX:2]"
aws s3api list-buckets --query 'Buckets[?contains(Name,`tektondemobuckets-tektondemochartmuseumbucket`)].Name' --output text
aws s3api list-buckets --query 'Buckets[?contains(Name,`tektondemobuckets-tektondemocodebucket`)].Name' --output text
echo ""
echo "-----------"

# Check Cluster
echo "[INFO] Check Cluster[MAX:1]"
aws eks list-clusters --query 'clusters' --output text
echo ""
echo "-----------"

# Check CloudWatchlogs for lambda
echo "[INFO] Check CloudWatch logs for lambda[MAX:1]"
aws logs describe-log-groups --query 'logGroups[?logGroupName==`/aws/lambda/TektonPipelineDemoWebhook`].logGroupName' --output text
echo ""
echo "-----------"

# Check Cloud9
echo "[INFO] Check Cloud9[MAX:1]"
aws cloud9 list-environments --query 'environmentIds[]' --output text | while read id;do aws cloud9 describe-environments --environment-ids $id --query 'environments[?name==`eks-handson`].name' --output text ;done
echo ""
echo "-----------"

# Check IAM User
echo "[INFO] Check IAM User[MAX:1]"
aws iam list-users --query 'Users[?UserName==`eks-handson-user`].UserName' --output text
echo ""
echo "-----------"

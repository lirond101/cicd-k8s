# !/bin/bash
AWS_REGION="us-east-2"

# echo "Executing terraform vpc" 
# cd ~/cicd-k8s/infrastructure/aws/vpc/
# terraform init
# terraform apply --auto-approve

echo "Executing terraform eks" 
cd ~/cicd-k8s/infrastructure/aws/eks/
# terraform init
# terraform apply --auto-approve
CLUSTER_NAME=$(terraform output -raw cluster_name)

echo "Provisioning kubernetes cluster $CLUSTER_NAME on $AWS_REGION"
cd ~/cicd-k8s/infrastructure/k8s/
./provision-k8s.sh $CLUSTER_NAME $AWS_REGION

echo "done setup project kandula!"



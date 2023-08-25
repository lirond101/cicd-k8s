#!/bin/bash
AWS_REGION="us-east-2"

echo "Destroying kubernetes cluster"
cd ~/cicd-k8s/infrastructure/k8s/
./cleanup-k8s.sh

echo "Destroying terraform eks" 
cd ~/cicd-k8s/infrastructure/aws/eks/
terraform destroy --auto-approve

echo "Destroying terraform vpc" 
cd ~/cicd-k8s/infrastructure/aws/vpc/
terraform destroy --auto-approve

echo "done destroy resources!!"

export AWS_PROFILE=employee2
CALLER_IDENTITY=$(aws sts get-caller-identity)
echo $CALLER_IDENTITY
cd ~/cicd-k8s/infrastructure/k8s

# KUBECONFIG
#TODO add with terraform another role to interact with cluster
echo "### Update kubeconfig with cluster name $1"
aws eks --region=$2 update-kubeconfig --name $1

# IAM
echo "### Get IAM Idneitity mapping from aws-auth"
eksctl get iamidentitymapping --cluster $1 --region=$2
echo "### Add Roles into configmap 'aws-auth'"
eksctl create iamidentitymapping --cluster  $1 --region=$2 --arn arn:aws:iam::902770729603:role/AdministratorAccess --group system:masters --username admin
eksctl create iamidentitymapping --cluster  $1 --region=$2 --arn arn:aws:iam::902770729603:role/allow_describe_ec2 --group system:masters --username dev1
eksctl get iamidentitymapping --cluster $1 --region=$2
# In case of error use the same user/role that created the cluster.
# echo "### Add employee2 to configmap 'aws-auth'"
# eksctl create iamidentitymapping \
#     --cluster $1 \
#     --region=$2 \
#     --arn arn:aws:iam::902770729603:user/employee2 \
#     --group system:masters \
#     --no-duplicate-arns

#AWS-LOAD-BALANCER-CONTROLLER
helm repo add eks https://aws.github.io/eks-charts
#Install the TargetGroupBinding CRDs:
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
#Install the AWS Load Balancer controller, if using iamserviceaccount: 
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$1 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

sleep 30
kubectl wait --namespace kube-system \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=aws-load-balancer-controller \
  --timeout=120s

# CERT-MANAGER
# helm repo add jetstack https://charts.jetstack.io
# helm install cert-manager jetstack/cert-manager --create-namespace --namespace cert-manager --version v1.12.0 --set installCRDs=true
# kubectl apply -f lets-encrypt/prod_issuer.yaml
# sleep 60

#JENKINS
kubectl create namespace jenkins
kubectl apply -f jenkins/jenkins-cluster-sa.yaml
kubectl apply -f jenkins/jenkins-sa-secret.yaml
kubectl apply -f jenkins/jenkins-pv-claim.yaml
kubectl apply -f jenkins/jenkins-app.yaml
kubectl apply -f jenkins/jenkins-ingress.yaml
sleep 120
kubectl -n jenkins describe secrets sa-jenkins

#ROUTE-53
INGRESS_LB_CNAME=$(kubectl get ingress jenkins-ingress -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" -n jenkins)
sed -i "s/google.com/$INGRESS_LB_CNAME/" route_53_change_batch.json
aws route53 change-resource-record-sets --hosted-zone-id Z01928206842WG4H1R0U --change-batch file://route_53_change_batch.json
sleep 60

# APP
# TODO Move as jenkins jobs
kubectl apply -f app/my-pub-ip-app.yaml
kubectl apply -f app/my-pub-ip-ingress.yaml
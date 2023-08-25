# Cleanup

INGRESS_LB_CNAME=$(kubectl get ingress jenkins-ingress -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" -n jenkins)
sed -i "s/$INGRESS_LB_CNAME/google.com/" route_53_change_batch.json

kubectl delete ingress my-pub-ip-ingress -n app
kubectl delete ingress jenkins-ingress -n jenkins

helm delete aws-load-balancer-controller -n kube-system

kubectl delete -f kandula/my-pub-ip-app.yaml
kubectl delete -f jenkins/jenkins-app.yaml

kubectl delete namespace jenkins
kubectl delete namespace app
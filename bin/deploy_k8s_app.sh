# ref: https://github.com/ianlewis/kubernetes-bluegreen-deployment-tutorial

DEPLOY_VERSION=$1
SVC_NAME='hello-app'

# Always create a new deployment
sed "s/TAGVERSION/$DEPLOY_VERSION/" k8s/deployment.yaml | kubectl apply -f -

# Create/Update service that expose this deployment
# In the case of an update, traffic will be switched to the new deployment.
sed "s/TAGVERSION/$DEPLOY_VERSION/" k8s/service.yaml | kubectl apply -f -

# Test
# ref: https://kubernetes.io/docs/reference/kubectl/jsonpath/
EXTERNAL_HOSTNAME=$(kubectl get svc $SVC_NAME -o=jsonpath="{.status.loadBalancer.ingress[*].hostname}")
echo `http://$EXTERNAL_HOSTNAME/`
curl -s http://$EXTERNAL_HOSTNAME/

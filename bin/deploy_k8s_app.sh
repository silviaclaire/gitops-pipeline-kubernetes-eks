# ref: https://github.com/ianlewis/kubernetes-bluegreen-deployment-tutorial
# jsonpath: https://kubernetes.io/docs/reference/kubectl/jsonpath/

VERSION=$1
SERVICE='hello-app'
DEPLOYMENT=$SERVICE-$1

# Always create a new deployment
sed "s/TAGVERSION/$VERSION/" k8s/deployment.yaml | kubectl apply -f -

# Wait until the Deployment is ready by checking the MinimumReplicasAvailable condition.
kubectl wait --for=condition=available --timeout=600s deployment/$DEPLOYMENT

# Create/Update service that expose this deployment
# In the case of an update, traffic will be switched to the new version.
sed "s/TAGVERSION/$VERSION/" k8s/service.yaml | kubectl apply -f -

# Test
EXTERNAL_HOSTNAME=$(kubectl get svc $SERVICE -o=jsonpath="{.status.loadBalancer.ingress[*].hostname}")
echo "http://$EXTERNAL_HOSTNAME/"
curl -s http://$EXTERNAL_HOSTNAME/

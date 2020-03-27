# ref: https://github.com/ianlewis/kubernetes-bluegreen-deployment-tutorial
# jsonpath: https://kubernetes.io/docs/reference/kubectl/jsonpath/

VERSION=$1
NAMESPACE=$2  # use branch name
SERVICE='hello-app'
DEPLOYMENT=$SERVICE-$1

check_status () {
    kubectl get services -n ${NAMESPACE}
    kubectl get deployments -n ${NAMESPACE}
    kubectl get pods -n ${NAMESPACE}
}

# Create namespace if it doesn't exist
kubectl get ns ${NAMESPACE} || kubectl create ns ${NAMESPACE}

# Always create a new deployment
sed "s/TAGVERSION/$VERSION/" k8s/${NAMESPACE}/deployment.yaml | kubectl -n ${NAMESPACE} apply -f -
check_status

# Wait until the Deployment is ready by checking the MinimumReplicasAvailable condition.
kubectl wait --for=condition=available --timeout=120s -n ${NAMESPACE} deployment/$DEPLOYMENT
check_status

# Create/Update service that expose this deployment
# In the case of an update, traffic will be switched to the new version.
sed "s/TAGVERSION/$VERSION/" k8s/${NAMESPACE}/service.yaml | kubectl -n ${NAMESPACE} apply -f -
# Wait a few seconds for the service become ready
# ref: For now Services do not have conditions in their status. (kubenetes #80828)
sleep 60
check_status

# Test
EXTERNAL_HOSTNAME=$(kubectl get svc $SERVICE -n ${NAMESPACE} -o=jsonpath="{.status.loadBalancer.ingress[*].hostname}")
echo "http://$EXTERNAL_HOSTNAME/"

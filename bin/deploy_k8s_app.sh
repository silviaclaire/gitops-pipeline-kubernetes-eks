# ref: https://github.com/ianlewis/kubernetes-bluegreen-deployment-tutorial

# Create Blue deployment
sed 's/TAGVERSION/1.0/' kubernetes/deployment.yaml | kubectl apply -f -

# Create the service
sed 's/TAGVERSION/1.0/' kubernetes/service.yaml | kubectl apply -f -

# Test Blue
EXTERNAL_IP=$(kubectl get svc hello-app -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
curl -s http://$EXTERNAL_IP/

# Update App

# Create Green deployment
sed 's/TAGVERSION/1.1/' kubernetes/deployment.yaml | kubectl apply -f -

# Switch traffic to Green
sed 's/TAGVERSION/1.1/' kubernetes/service.yaml | kubectl apply -f -

# Test Green
EXTERNAL_IP=$(kubectl get svc hello-app -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
curl -s http://$EXTERNAL_IP/

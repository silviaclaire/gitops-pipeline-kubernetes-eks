# ref: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

AWS_REGION=$1
CLUSTER_NAME=$2

# chmod +x bin/create_or_update_stack.sh

# Create Amazon EKS Service Role
./bin/create_or_update_stack.sh $AWS_REGION eks-role cloudformation/role.yaml

# Create Amazon EKS Cluster VPC
./bin/create_or_update_stack.sh $AWS_REGION eks-vpc cloudformation/vpc.yaml

# Create Amazon EKS Cluster
sed -i "s/CLUSTER_NAME/$CLUSTER_NAME/" cloudformation/cluster.yaml
./bin/create_or_update_stack.sh $AWS_REGION eks-cluster cloudformation/cluster.yaml

# Create/Update kubeconfig File for cluster
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

# Test the configuration
kubectl get svc

# NOTE: Wait for your cluster status to show as ACTIVE
# Launch a Managed Node Group
./bin/create_or_update_stack.sh $AWS_REGION eks-nodegroup cloudformation/nodegroup.yaml

# Test
kubectl get nodes

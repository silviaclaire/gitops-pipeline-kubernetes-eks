# ref: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

# Create Amazon EKS Service Role
aws cloudformation create-stack \
    --stack-name eks-role \
    --template-body file://role.yaml \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"

# Create Amazon EKS Cluster VPC
aws cloudformation create-stack \
    --stack-name eks-vpc \
    --template-body file://vpc.yaml \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"

# Create Amazon EKS Cluster
aws cloudformation create-stack \
    --stack-name eks-cluster \
    --template-body file://cluster.yaml \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"

# Create/Update kubeconfig File for cluster
aws eks update-kubeconfig \
    --region us-west-2 \
    --name aws-eks-cluster

# Test the configuration
kubectl get svc

# NOTE: Wait for your cluster status to show as ACTIVE
# Launch a Managed Node Group
aws cloudformation create-stack \
    --stack-name eks-nodegroup \
    --template-body file://nodegroup.yaml \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"

# Test
kubectl get nodes

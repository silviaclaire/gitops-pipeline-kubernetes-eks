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

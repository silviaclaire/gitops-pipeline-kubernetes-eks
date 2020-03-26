# install JDK
sudo apt install -y default-jdk

# install jenkins
# ref: https://jenkins.io/doc/book/installing/#debianubuntu
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
systemctl status jenkins
cat /var/lib/jenkins/secrets/initialAdminPassword
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# install docker
# ref: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
docker

# enable docker in jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
systemctl status jenkins

# install awscli v2
# ref: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version
aws configure
aws s3 ls

# install eksctl
# ref: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# install kubectl
# ref: https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# install aws-iam-authenticator
# ref: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html#linux
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
aws-iam-authenticator help

# install pip
sudo apt-get install python3-pip
pip3 --version

# install CI/CD libraries
sudo apt install ansible tidy
pip3 install boto pylint pytest

# install linter for Dockerfile
sudo wget -O /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.5/hadolint-Linux-x86_64
sudo chmod +x /usr/bin/hadolint
hadolint

# show remaining space on EC2
df -v

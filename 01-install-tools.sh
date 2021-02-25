# Prepare EKS Cluster

## Install kubectl
echo '------ install kubectl -------'
sudo curl --silent --location -o /usr/local/bin/kubectl \
    https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.11/2020-09-18/bin/linux/amd64/kubectl

sudo chmod +x /usr/local/bin/kubectl

## Update awscli
echo '------ update aws cli -------'
cd ~/environment
sudo mv /usr/bin/aws /usr/local/bin/
echo 'export PATH=$PATH:$HOME/local/bin' >>~/.bash_profile
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

## Install jq. envsubst and bash-completition
echo '------ install jq -------'
sudo yum -y install jq gettext bash-completion moreutils

## Verify the binaries are in the path and executable

for command in kubectl jq envsubst aws; do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
done

## Enable kubectl bash_completion

kubectl completion bash >>~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion

## Ensure no temporary credentials

# rm -vf ${HOME}/.aws/credentials

# ## configure aws region as default

# export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
# export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
# export AZS=($(aws ec2 describe-availability-zones --query 'AvailabilityZones[].ZoneName' --output text --region ap-southeast-1))

# ## Check Region

# test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set

# ## Save to bash_profile

# echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
# echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
# echo "export AZS=(${AZS[@]})" | tee -a ~/.bash_profile
# aws configure set default.region ${AWS_REGION}
# aws configure get default.region

# ## Validate the IAM role
# echo '------ validate iam role -------'
# aws sts get-caller-identity --query Arn | grep eksworkshop-admin -q && echo "IAM role valid" || echo "IAM role NOT valid"

## Gen key to account (enter 3 times to finised)

# ssh-keygen

## Upload public key to account

# aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub

## Create a CMK for cluster

# aws kms create-alias --alias-name alias/eksworkshop --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)

## Get Key ARN

# export MASTER_ARN=$(aws kms describe-key --key-id alias/eksworkshop --query KeyMetadata.Arn --output text)

## Set to bash_profile

# echo "export MASTER_ARN=${MASTER_ARN}" | tee -a ~/.bash_profile

## Install eksctl
# echo '------ install eksctl -------'
# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# sudo mv -v /tmp/eksctl /usr/local/bin

# ## Enable bash-completion

# eksctl completion bash >>~/.bash_completion
# . /etc/profile.d/bash_completion.sh
# . ~/.bash_completion

## Install Istio CLI
echo '------ install istio cli -------'

echo 'export ISTIO_VERSION="1.9.0"' >>${HOME}/.bash_profile
source ${HOME}/.bash_profile

cd ~/environment
curl -L https://istio.io/downloadIstio | sh -

cd ${HOME}/environment/istio-${ISTIO_VERSION}

sudo cp -v bin/istioctl /usr/local/bin/
istioctl version --remote=false

## Install Argo CLI
echo '------ install argo cli -------'
# set argo version
export ARGO_VERSION="v2.9.1"
# Download the binary
sudo curl -sSL -o /usr/local/bin/argo https://github.com/argoproj/argo/releases/download/${ARGO_VERSION}/argo-linux-amd64

# Make binary executable
sudo chmod +x /usr/local/bin/argo

# Test installation
argo version --short

#!/bin/bash

# make installation directry
mkdir -p $HOME/bin/

# install bash-completion & docker
sudo dnf install -y bash-completion docker

# install aws-iam-authenticator
curl -fsSL "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.14/aws-iam-authenticator_0.6.14_linux_amd64"  -o $HOME/bin/aws-iam-authenticator
chmod +x $HOME/bin/aws-iam-authenticator

# install eksctl
## https://eksctl.io/installation/
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
mv /tmp/eksctl $HOME/bin

# install kubectl
## https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/
curl -LO "https://dl.k8s.io/release/$(curl -LS https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl $HOME/bin/kubectl

# install helm
## https://helm.sh/ja/docs/intro/install/
curl -fsSL -o helm.tar.gz "https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz"
tar -zxvf helm.tar.gz
mv linux-amd64/helm $HOME/bin/
rm helm.tar.gz
rm -r linux-amd64

# export path
echo 'export PATH=$PATH:$HOME/bin' >> $HOME/.bashrc
echo 'source /etc/profile.d/bash_completion.sh' >> $HOME/.bashrc
echo 'source <(eksctl completion bash)' >> $HOME/.bashrc
echo 'source <(kubectl completion bash)' >> $HOME/.bashrc
echo 'source <(helm completion bash)' >> $HOME/.bashrc
echo 'alias k="kubectl"' >> $HOME/.bashrc
echo 'complete -o default -F __start_kubectl k' >> $HOME/.bashrc

echo ''
echo '--------------------------'
echo 'set_up complete!'
echo 'you can completion eksctl, kubectl,helm after execute this command.'
echo 'source ~/.bashrc'


#!/bin/bash 

# Stop script when exit code is not 0
set -e

cd /tmp

echo "Install kind"
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-linux-amd64
sudo mv kind-linux-amd64 /usr/bin/kind
sudo chmod 755 /usr/bin/kind
echo "Kind installed"

echo "Install kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl
sudo mv kubectl /usr/bin/kubectl
sudo chmod 755 /usr/bin/kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
source <(kubectl completion bash)  
echo "Kubectl installed"

echo "Install helm and tiller" 
wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -xvzf helm-v2.14.3-linux-amd64.tar.gz 
cd linux-amd64/
sudo mv helm tiller /usr/bin/
sudo chmod 755 /usr/bin/helm
sudo chmod 755 /usr/bin/tiller
rm -f helm-v2.14.3-linux-amd64.tar.gz
echo "Helm and tiller installed"

echo "Fix workaround cgroup error"
sudo mkdir /sys/fs/cgroup/systemd
sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
echo "Fixed"

echo "Start k8s kind cluster"
kind create cluster --config /home/docker/kind-cluster.yml --name local-cluster
sleep 5
echo "Cluster created"

echo "Test cluster"
export KUBECONFIG="$(kind get kubeconfig-path --name="local-cluster")"
kubectl get nodes
echo "Test completed"

echo "install rancher"
mkdir /home/docker/rancher-data
docker run -d  --name rancher --restart=unless-stopped -p 80:80 -p 443:443 -v /home/docker/rancher-data:/var/lib/rancher rancher/rancher:v2.3.0
sleep 10
docker restart rancher
sleep 10
curl -k https://127.0.0.1
echo "Rancher installed"


#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# this script supports Ubuntu 20.04 LTS and later only
# run this script with sudo

if ! [ $USER = root ]
then
	echo run this script with sudo
	exit 3
fi

# setting k8s version
K8S_VERSION="v1.28"

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

if [ $MYOS = "Ubuntu" ]
then
	echo RUNNING UBUNTU CONFIG
	cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
	br_netfilter
EOF
	
	sudo apt-get update && sudo apt-get install -y apt-transport-https curl

	K8S_KEYRING_FILE="/etc/apt/keyrings/kubernetes-apt-keyring.gpg"
	rm -f "$K8S_KEYRING_FILE" 2>/dev/null
	curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" | sudo gpg --dearmor -o "${K8S_KEYRING_FILE}"
	echo "deb [signed-by=${K8S_KEYRING_FILE}] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	swapoff -a
	
	sed -i 's/\/swap/#\/swap/' /etc/fstab
fi

# Set iptables bridging
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

sudo mkdir -p /etc/bash_completion.d/

for c in kubectl kubeadm crictl
do
  "$c" completion bash > "/etc/bash_completion.d/$c"
done

sudo crictl config --set \
    runtime-endpoint=unix:///run/containerd/containerd.sock
echo 'after initializing the control node, follow instructions and use kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml to install the calico plugin (control node only). On the worker nodes, use sudo kubeadm join ... to join'

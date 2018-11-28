#! /bin/bash

# 关闭Swap

# 系统防火墙和安全配置（iptables SELinux）

# CentOS7/RHEL7
# $ cat <<EOF >  /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
# EOF
# $ sudo sysctl --system

curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt install -y docker-ce=18.06.1~ce~3-0~ubuntu
apt-mark hold docker-ce

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add - 
add-apt-repository "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main"

apt-get install -y kubelet kubeadm
apt-mark hold kubelet kubeadm kubectl

apt-get install -y ipset

modprobe -- ip_vs 
modprobe -- ip_vs_rr 
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
# (linux kubernel 4.19 and later)
modprobe -- nf_conntrack 
# modprobe -- nf_conntrack_ipv4

kubeadm init --pod-network-cidr=10.5.0.0/16 --kubernetes-version=v1.12.2 --apiserver-advertise-address=192.168.33.11


# Kubectl配置（对于非root用户）
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# CNI 
wget https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
wget https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
kubectl apply -f rbac-kdd.yaml
# 修改calico.yaml中关于网段内容为规划的网络段10.5.0.0/16
kubectl apply -f calico.yaml



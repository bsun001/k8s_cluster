#!/bin/bash

## Disable Selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

## Update IP table setting
## This ensures that packets are properly processed by IP tables during filtering and port forwarding.

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

## Disable Swap

sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a

## Add Kubernetes Repo

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

## Add Docker Repo

cat <<EOF > /etc/yum.repos.d/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/\$releasever/debug-\$basearch/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/\$releasever/source/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF

## Install kubeadm and docker

yum -y remove podman-docker runc

yum install -y kubelet-1.25.0 kubeadm-1.25.0 kubectl-1.25.0 --disableexcludes=kubernetes
yum install -y docker-ce docker-ce-cli containerd.io

## Configure containerd
containerd config default > /etc/containerd/config.toml

sed -i -e "s|disabled_plugins|#disabled_plugins|g" /etc/containerd/config.toml

sed -i -e "s|registry.k8s.io/pause:3.6|registry.aliyuncs.com/google_containers/pause:3.9|g" /etc/containerd/config.toml

systemctl restart containerd

## Start and enable docker, kubelet service

systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet

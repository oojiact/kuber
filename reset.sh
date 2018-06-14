#!/bin/sh
kubeadm reset && systemctl daemon-reload && systemctl restart docker.service && systemctl restart kubelet.service && swapoff -a && kubeadm init
mkdir -p $HOME/.kube
sudo cp  /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#!/bin/sh
setenforce 0
service firewalld stop
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#firewall-cmd --permanent --add-port=6443/tcp && firewall-cmd --permanent --add-port=2379-2380/tcp && firewall-cmd --permanent --add-port=10250/tcp && firewall-cmd --permanent --add-port=10251/tcp && firewall-cmd --permanent --add-port=10252/tcp && firewall-cmd --permanent --add-port=10255/tcp && firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y wget
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
chmod +x docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
rpm -ivh docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install -y yum-utils
yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-17.03.1.ce-1.el7.centos
yum install -y kubelet kubeadm kubectl
systemctl enable docker.service
systemctl start docker.service
systemctl enable kubelet && systemctl start kubelet
sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
swapoff -a

kubeadm reset

echo 'Environment=KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kebeadm.conf

systemctl daemon-reload
systemctl restart kubelet

kubeadm init

#Not yet tested

#default microk8s installation
sudo snap install microk8s --classic
sudo usermod -a -G microk8s `whoami`
newgrp microk8s
microk8s.status --wait-ready
microk8s.enable storage dns
microk8s.enable dashboard
microk8s.config > kubeconfig.yaml

#istio
microk8s.enable istio

#prometheus
microk8s.kubectl apply -f ./deploy/kubernetes/manifests-monitoring/

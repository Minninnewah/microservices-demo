#!/bin/bash

sudo snap alias microk8s.kubectl kubectl
curl -sSL https://mirrors.chaos-mesh.org/v2.1.5/install.sh | bash -s -- --template | kubectl delete -f -
kubectl patch crd/stresschaos.chaos-mesh.org -p '{"metadata":{"finalizers":[]}}' --type=merge
microk8s.kubectl delete -f ./deploy/kubernetes/complete-demo.yaml

namespaceStatus=$(kubectl get ns sock-shop -o json | js .status.phase -r)
while [ $namespaceStatus == "Active" | $namespaceStatus == "Terminating"]
do
        echo "."
done

microk8s.kubectl create namespace sock-shop
microk8s.kubectl label namespace sock-shop istio-injection=enabled --overwrite
microk8s.kubectl apply -f ./deploy/kubernetes/complete-demo.yaml


curl -sSL https://mirrors.chaos-mesh.org/v2.1.5/install.sh | bash -s -- --microk8s
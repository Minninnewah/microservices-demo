#!/bin/bash

REQUIRED_PKG=jq
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

sudo snap alias microk8s.kubectl kubectl

echo "-----Delete chaos mesh-----"
kubectl patch crd/stresschaos.chaos-mesh.org -p '{"metadata":{"finalizers":[]}}' --type=merge
curl -sSL https://mirrors.chaos-mesh.org/v2.1.5/install.sh | bash -s -- --template | kubectl delete -f -

echo "-----Delete sock-shop-----"
timeout 1m microk8s.kubectl delete -f ./deploy/kubernetes/complete-demo.yaml

namespaceStatus=$(kubectl get ns sock-shop -o json | jq .status.phase -r)
while (($namespaceStatus == "Active" || $namespaceStatus == "Terminating"))
do
        echo -n "."
done

echo "-----Deploy sock-shop-----"
microk8s.kubectl create namespace sock-shop
microk8s.kubectl label namespace sock-shop istio-injection=enabled --overwrite
microk8s.kubectl apply -f ./deploy/kubernetes/complete-demo.yaml

echo "-----Deploy chaos mesh-----"
curl -sSL https://mirrors.chaos-mesh.org/v2.1.5/install.sh | bash -s -- --microk8s
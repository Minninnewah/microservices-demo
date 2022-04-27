microk8s.kubectl delete -f ./deploy/kubernetes/complete-demo.yaml
microk8s.kubectl create namespace sock-shop
microk8s.kubectl label namespace sock-shop istio-injection=enabled --overwrite
microk8s.kubectl apply -f ./deploy/kubernetes/complete-demo.yaml
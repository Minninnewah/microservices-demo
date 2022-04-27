nohup microk8s kubectl port-forward -n chaos-testing service/chaos-dashboard  --address 10.161.2.161 2333:2333 & #Chaos dashboard
nohup microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard --address 10.161.2.161 10443:443 & #Kubernetes Dashboard
nohup microk8s kubectl port-forward -n sock-shop service/iot-handler-evil --address 10.161.2.161 3002:3002 & #Evil IoT-handler
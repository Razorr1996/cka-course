# Scheduling a Pod
```shell
kubectl run lab123 --image=nginx --dry-run=client -o yaml > lab123.yaml
# edit
kubectl apply -f lab123.yaml
```

# Managing Application Initialization
```shell
kubectl run lab124deploy --image=busybox --dry-run=client -o yaml -- sleep 30 > lab124deploy.yaml
# edit
kubectl apply -f lab124deploy.yaml
```

# Setting up Persistent Storage
```shell
kubectl apply -f lab125.yaml
```

# Configuring Application Access
```shell
kubectl create deployment lab126deploy --image=nginx --replicas=3
kubectl expose deployment lab126deploy --port=80

kubectl edit service lab126deploy
# curl ClusterIP from node terminal
# curl 10.97.165.224:80
```

# Securing Network Traffic
```shell
kubectl create ns resricted
kubectl create ns access
kubectl apply -f lab127.yaml
```

# Setting up Quota
```shell
kubectl create ns limited
kubectl create quota lab128 --hard=memory=2Gi,pods=5 -n limited
kubectl create -n limited deployment lab128deploy --image=nginx --replicas=3
kubectl set resources deployment lab128deploy --limits=memory=256Mi --requests=memory=128Mi -n limited
kubectl describe ns limited
```

# Creating a Static Pod
```shell
kubectl run lab129pod --image=nginx --dry-run=client -o yaml
# ssh worker2
ssh cka1-worker2.shared
sudo vim /etc/kubernetes/manifests/lab129pod.yaml
kubectl get pods
```

# Troubleshooting Node Services
```shell
kubectl get nodes -o wide
# ssh worker2
ssh cka1-worker2.shared
sudo systemctl status kubelet.service
sudo journalctl -u kubelet.service

sudo systemctl status containerd.service
sudo journalctl -u containerd.service
```

# Configuring Cluster Access
```shell
kubectl create ns access
kubectl create role lab1211 --verb=get,list,watch,create,update,delete,patch --resource=pods,deployments,daemonsets,statefulsets -n access
kubectl create sa lab1211 -n access
kubectl create -n access rolebinding lab1211 --role=lab1211 --serviceaccount=access:lab1211
```

# Configuring Taints and Tolerations
```shell
# Taint
kubectl taint node cka1-worker2 type=db:NoSchedule

# check
kubectl apply -f lab1212.yaml

# Untaint
kubectl taint node cka1-worker2 type=db:NoSchedule-
```

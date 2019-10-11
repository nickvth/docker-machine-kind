# docker-machine-kind

Use kind with docker-machine and virtualbox

Create vm
```
docker-machine create -d virtualbox --virtualbox-cpu-count "2" --virtualbox-disk-size "60000" --virtualbox-memory "8196" kind
```

SSH to vm
```
docker-machine ssh kind
```

Create kind cluster config
```
vi kind-cluster.yml
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
nodes:
- role: control-plane
  extraPortMappings:                                          
  - containerPort: 30080                                      
    hostPort: 8080 
- role: worker
- role: worker
- role: worker
```

Add bash script (see in this repo [install.sh](install.sh)) to install and configure all requirements
```
vi install.sh
script
```

Execute script
```
chmod +x install.sh
./install.sh
```

Use your new cluster
```
export KUBECONFIG="$(kind get kubeconfig-path --name="local-cluster")"
source /etc/profile
kubectl get nodes
```



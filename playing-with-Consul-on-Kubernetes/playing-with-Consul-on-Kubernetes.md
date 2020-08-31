# Playing with Consul on Kubernetes

## Install Helm

```text
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version
```

## Install Consul

```text
helm repo add hashicorp https://helm.releases.hashicorp.com
```

```text
helm search repo hashicorp/consul
```

```text
touch helm-consul-values.yaml
```

```yaml
global:
  datacenter: consul-dc-01
  acls:
    manageSystemACLs: true

ui:
  service:
    type: 'LoadBalancer'

connectInject:
  enabled: true

syncCatalog:
  enabled: true

client:
  enabled: true
  grpc: true

server:
  replicas: 3
  bootstrapExpect: 3
```

```text
helm install -f helm-consul-values.yaml hashicorp hashicorp/consul
```

```text
kubectl get pods --all-namespaces
```

```text
kubectl get services --all-namespaces
```

```text
kubectl exec -it hashicorp-consul-server-0 /bin/sh
```

```text
consul members
exit
```

```text
$ kubectl get secrets hashicorp-consul-bootstrap-acl-token --template={{.data.token}} | base64 -d
b68b6149-961c-b4be-4b80-05c4e7fe4b57
```

## Install and Run the Demo

```yaml
# k8s.yaml
---
# Deploy 'service-a' Service Account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-a
---
# Deploy 'service-a-version-1-0-0-deployment' Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a-version-1-0-0-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-a
      version: 1.0.0
  template:
    metadata:
      labels:
        app: service-a
        version: 1.0.0
        api: acme-api
      annotations:
        "consul.hashicorp.com/connect-inject": "true"
        "consul.hashicorp.com/connect-service": "service-a"
        "consul.hashicorp.com/connect-service-port": "service-a-port"
    spec:
      ## If ACLs are enabled, the serviceAccountName must match the Consul service name.
      serviceAccountName: service-a
      containers:
      - name: service-a
        image: patrice1972/service-a:1.0.0
        ports:
        - name: service-a-port
          protocol: TCP
          containerPort: 3000
---
# Deploy 'client-x' Service Account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: client-x
---
# Deploy 'client-x-version-1-0-1-deployment' Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: client-x-version-1-0-1-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: client-x
      version: 1.0.1
  template:
    metadata:
      labels:
        app: client-x
        version: 1.0.1
      annotations:
        "consul.hashicorp.com/connect-inject": "true"
        "consul.hashicorp.com/connect-service-upstreams": "service-a:3000"
    spec:
      serviceAccountName: client-x
      containers:
      - name: client-x
        image: patrice1972/client-x:1.0.1
        env:
        - name: API_HOST
          value: "localhost"
```

```text
$ kubectl apply -f k8s.yaml
serviceaccount/service-a created
deployment.apps/service-a-version-1-0-0-deployment created
serviceaccount/client-x created
deployment.apps/client-x-version-1-0-1-deployment created
```

```text
$ kubectl get pods
NAME                                                              READY   STATUS    RESTARTS   AGE
client-x-version-1-0-1-deployment-7dbc66df47-whsdj                3/3     Running   0          102s
hashicorp-consul-5zjdb                                            1/1     Running   0          63m
hashicorp-consul-connect-injector-webhook-deployment-b9888zm4hm   1/1     Running   0          63m
hashicorp-consul-nr9jd                                            1/1     Running   0          63m
hashicorp-consul-server-0                                         1/1     Running   0          63m
hashicorp-consul-server-1                                         1/1     Running   0          63m
hashicorp-consul-server-2                                         1/1     Running   0          63m
hashicorp-consul-sync-catalog-6fbbfc9b-gnt7d                      1/1     Running   0          63m
hashicorp-consul-t6h7x                                            1/1     Running   0          63m
service-a-version-1-0-0-deployment-64667df67b-tgc56               3/3     Running   0          68s
```

```text
$ kubectl logs client-x-version-1-0-1-deployment-7dbc66df47-whsdj client-x | tail
[INFO] get /path-01 | 000
[INFO] get /path-02 | 000
[INFO] get /path-01 | 000
...
```

```text
kubectl exec -it hashicorp-consul-server-0 /bin/sh
```

```text
# consul intention create -token=b68b6149-961c-b4be-4b80-05c4e7fe4b57 -allow client-x service-a
Created: client-x => service-a (allow)
```

```text
$ kubectl logs client-x-version-1-0-1-deployment-7dbc66df47-whsdj client-x | tail
[INFO] get /path-01 | Hello from get /path-01 | service-a (1.0.0) | service-a-version-1-0-0-deployment-64667df67b-tgc56
[INFO] get /path-02 | Hello from get /path-02 | service-a (1.0.0) | service-a-version-1-0-0-deployment-64667df67b-tgc56
[INFO] get /path-01 | Hello from get /path-01 | service-a (1.0.0) | service-a-version-1-0-0-deployment-64667df67b-tgc56
...
```

## References

<https://www.consul.io/docs/k8s/installation/overview>
<https://www.consul.io/docs/k8s/helm>
<https://learn.hashicorp.com/consul/gs-consul-service-mesh/deploy-consul-service-mesh>

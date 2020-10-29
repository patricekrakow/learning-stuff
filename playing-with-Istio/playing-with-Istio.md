# Playing with Istio

## Prerequisites

You must have a running _Kubernetes_ cluster, and an access to it via the `kubectl` CLI. You can follow one of these documents to get a proper environment:

* [Playing with Minikube](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-Minikube.md)
* [Playing with Azure Kubernetes Service (AKS)](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-AKS.md)

```text
$ kubectl version --short
Client Version: v1.18.8
Server Version: v1.17.11
```

## Install Istio

1\. Download Istio and configure `istioctl`:

```text
$ curl -L https://istio.io/downloadIstio | sh -
$ ls
...  istio-1.7.3 ...
$ cd istio-1.7.3
$ export PATH=$PWD/bin:$PATH
$ istioctl version
no running Istio pods in "istio-system"
1.7.3
```

2\. Install Istio control plane within the Kubernetes cluster:

```text
$ istioctl install --set profile=default
✔ Istio core installed
✔ Istiod installed
✔ Ingress gateways installed
✔ Installation complete  
```

3\. Verify the installation of Istio:

```text
$ kubectl get pods --namespace istio-system
NAME                                   READY   STATUS    RESTARTS   AGE
istio-ingressgateway-5689f7c67-dcfs6   1/1     Running   0          2m2s
istiod-5c6b7b5b8f-x7wn8                1/1     Running   0          2m20s
```

## Install and Run the Demo

1\. Deploy the demonstration with Kubernetes manifests:

```text
$ kubectl apply -f 01.demo.k8s.yaml
namespace/istio-demo created
serviceaccount/service-a created
deployment.apps/service-a-v1-0-0-deployment created
service/acme-api created
serviceaccount/client-x created
deployment.apps/client-x-v1-0-0-deployment created
```

```text
$ kubectl get pods -n istio-demo
NAME                                          READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-58cf88bcf5-xgqh4   1/1     Running   0          24s
service-a-v1-0-0-deployment-994cf8fc8-j2stt   1/1     Running   0          24s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-xgqh4 -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-j2stt
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-j2stt
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-j2stt
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-j2stt
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-j2stt
```

## Onboard Services into the Mesh

```text
$ kubectl label namespace istio-demo istio-injection=enabled
namespace/istio-demo labeled
```

```text
$ kubectl delete pods --all -n istio-demo
pod "client-x-v1-0-0-deployment-58cf88bcf5-xgqh4" deleted
pod "service-a-v1-0-0-deployment-994cf8fc8-j2stt" deleted
```

```text
$ kubectl get pods -n istio-demo
NAME                                          READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-58cf88bcf5-nknl4   2/2     Running   0          79s
service-a-v1-0-0-deployment-994cf8fc8-8b8xl   2/2     Running   0          79s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-nknl4 client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
```

```text
$ kubectl apply -f 02.deny-all.istio.yaml
peerauthentication.security.istio.io/peer-policy created
authorizationpolicy.security.istio.io/deny-all created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-nknl4 client-x -n istio-demo | tail
[INFO] get /path-01 | 403
[INFO] get /path-01 | 403
[INFO] get /path-01 | 403
...
[INFO] get /path-01 | 403
[INFO] get /path-01 | 403
```

```text
$ kubectl apply -f 03.allow.istio.yaml
authorizationpolicy.security.istio.io/allow-client-x-to-service-a-through-alpha-api-routes created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-nknl4 client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-8b8xl
```

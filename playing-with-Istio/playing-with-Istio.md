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
...  istio-1.7.4 ...
$ cd istio-1.7.4/
$ export PATH=$PWD/bin:$PATH
$ cd ..
$ istioctl version
no running Istio pods in "istio-system"
1.7.4
```

2\. Install Istio control plane within the Kubernetes cluster:

```text
$ istioctl install --set profile=demo
✔ Istio core installed
✔ Istiod installed
✔ Egress gateways installed
✔ Ingress gateways installed
✔ Installation complete
```

3\. Verify the installation of Istio:

```text
$ kubectl get pods --namespace istio-system
NAME                                   READY   STATUS    RESTARTS   AGE
istio-egressgateway-69c9745b7-gp6ks    1/1     Running   0          57s
istio-ingressgateway-5cb9d7c76-bdm96   1/1     Running   0          57s
istiod-68657c94b5-wtt7t                1/1     Running   0          75s
```

## Install and Run the Demo

1\. Get the manifests from GitHub:

```text
$ git clone https://github.com/patricekrakow/learning-stuff.git
Cloning into 'learning-stuff'...
remote: Enumerating objects: 227, done.
remote: Counting objects: 100% (227/227), done.
remote: Compressing objects: 100% (175/175), done.
remote: Total 227 (delta 119), reused 140 (delta 48), pack-reused 0
Receiving objects: 100% (227/227), 57.91 KiB | 0 bytes/s, done.
Resolving deltas: 100% (119/119), done.
Checking connectivity... done.
$ cd learning-stuff/playing-with-Istio/
```

2\. Deploy the demonstration with Kubernetes manifests:

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
client-x-v1-0-0-deployment-58cf88bcf5-smn57   1/1     Running   0          21s
service-a-v1-0-0-deployment-994cf8fc8-srd67   1/1     Running   0          22s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-smn57 -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-srd67
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-srd67
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-srd67
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-srd67
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-srd67
```

## Onboard Services into the Mesh

```text
$ kubectl label namespace istio-demo istio-injection=enabled
namespace/istio-demo labeled
```

```text
$ kubectl delete pods --all -n istio-demo
pod "client-x-v1-0-0-deployment-58cf88bcf5-smn57" deleted
pod "service-a-v1-0-0-deployment-994cf8fc8-srd67" deleted
```

```text
$ kubectl get pods -n istio-demo
NAME                                          READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-58cf88bcf5-mqp9s   2/2     Running   0          62s
service-a-v1-0-0-deployment-994cf8fc8-wd9wg   2/2     Running   0          62s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-mqp9s client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
```

```text
$ kubectl apply -f 02.deny-all.istio.yaml
peerauthentication.security.istio.io/peer-policy created
authorizationpolicy.security.istio.io/deny-all created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-mqp9s client-x -n istio-demo | tail
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
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-mqp9s client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-wd9wg
```

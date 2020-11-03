# Playing with Istio

## Prerequisites

You must have a running _Kubernetes_ cluster, and an access to it via the `kubectl` CLI. You can follow one of these documents to get a proper environment:

* [Playing with Minikube](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-Minikube.md)
* [Playing with Azure Kubernetes Service (AKS)](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-AKS.md)

```text
$ kubectl version --short
Client Version: v1.19.3
Server Version: v1.17.13
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
istio-egressgateway-69c9745b7-ww5rd    1/1     Running   0          78s
istio-ingressgateway-5cb9d7c76-cgbvx   1/1     Running   0          78s
istiod-68657c94b5-8fmjs                1/1     Running   0          97s
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
client-x-v1-0-0-deployment-58cf88bcf5-tm2fm   1/1     Running   0          16s
service-a-v1-0-0-deployment-994cf8fc8-zmsz5   1/1     Running   0          16s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-tm2fm -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-zmsz5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-zmsz5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-zmsz5
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-zmsz5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-zmsz5
```

## Onboard Services into the Mesh

```text
$ kubectl label namespace istio-demo istio-injection=enabled
namespace/istio-demo labeled
```

```text
$ kubectl delete pods --all -n istio-demo
pod "client-x-v1-0-0-deployment-58cf88bcf5-tm2fm" deleted
pod "service-a-v1-0-0-deployment-994cf8fc8-zmsz5" deleted
```

```text
$ kubectl get pods -n istio-demo
NAME                                          READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-58cf88bcf5-77kx5   2/2     Running   0          88s
service-a-v1-0-0-deployment-994cf8fc8-cqcw5   2/2     Running   0          88s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-77kx5 client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
```

```text
$ kubectl apply -f 02.deny-all.istio.yaml
peerauthentication.security.istio.io/peer-policy created
authorizationpolicy.security.istio.io/deny-all created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-77kx5 client-x -n istio-demo | tail
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
$ kubectl logs client-x-v1-0-0-deployment-58cf88bcf5-77kx5 client-x -n istio-demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-994cf8fc8-cqcw5
```

## Install and Configure Grafana, Kiali, Prometheus and Tracing

```text
$ cd ~
$ cd cd istio-1.7.4/
$ kubectl apply -f samples/addons
...
```

> If there are errors trying to install the addons, try running the command again. There may be some timing issues which will be resolved when the command is run again.

```text
$ export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io
$ echo $INGRESS_DOMAIN
51.136.77.229.nip.io
```

### Configure Grafana

```text
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http-grafana
      protocol: HTTP
    hosts:
    - "grafana.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana-vs
  namespace: istio-system
spec:
  hosts:
  - "grafana.${INGRESS_DOMAIN}"
  gateways:
  - grafana-gateway
  http:
  - route:
    - destination:
        host: grafana
        port:
          number: 3000
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: grafana
  namespace: istio-system
spec:
  host: grafana
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF
```

<http://grafana.51.136.77.229.nip.io>

### Configure Kiali

```text
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kiali-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http-kiali
      protocol: HTTP
    hosts:
    - "kiali.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kiali-vs
  namespace: istio-system
spec:
  hosts:
  - "kiali.${INGRESS_DOMAIN}"
  gateways:
  - kiali-gateway
  http:
  - route:
    - destination:
        host: kiali
        port:
          number: 20001
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: kiali
  namespace: istio-system
spec:
  host: kiali
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF
```

<http://kiali.51.136.77.229.nip.io>

### Configure Prometheus

```text
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: prometheus-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http-prom
      protocol: HTTP
    hosts:
    - "prometheus.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: prometheus-vs
  namespace: istio-system
spec:
  hosts:
  - "prometheus.${INGRESS_DOMAIN}"
  gateways:
  - prometheus-gateway
  http:
  - route:
    - destination:
        host: prometheus
        port:
          number: 9090
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: prometheus
  namespace: istio-system
spec:
  host: prometheus
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF
```

<http://prometheus.51.136.77.229.nip.io>

### Configure Tracing

```text
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: tracing-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http-tracing
      protocol: HTTP
    hosts:
    - "tracing.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: tracing-vs
  namespace: istio-system
spec:
  hosts:
  - "tracing.${INGRESS_DOMAIN}"
  gateways:
  - tracing-gateway
  http:
  - route:
    - destination:
        host: tracing
        port:
          number: 80
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: tracing
  namespace: istio-system
spec:
  host: tracing
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF
```

<http://tracing.51.136.77.229.nip.io>

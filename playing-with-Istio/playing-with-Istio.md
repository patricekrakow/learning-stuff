# Playing with Istio

## Prerequisites

## Install Istio

1\. Download Istio and configure `istioctl`:

```text
$ curl -L https://istio.io/downloadIstio | sh -
$ cd istio-1.7.1
$ export PATH=$PWD/bin:$PATH
$ istioctl version
no running Istio pods in "istio-system"
1.7.1
```

2\. Install Istio control plane within the Kubernetes cluster:

```text
$ istioctl install --set profile=minimal
✔ Istio core installed
✔ Istiod installed
✔ Installation complete
```

3\. Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application later:

```text
$ kubectl create namespace demo
namespace/demo created
$ kubectl label namespace demo istio-injection=enabled
namespace/demo labeled
```

## Install the demo


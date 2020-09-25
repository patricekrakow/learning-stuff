# Playing with Microsoft Open Service Mesh (OSM)

## Prerequisite(s)

You must have a running _Kubernetes_ cluster, and an access to it via the `kubectl` CLI. You can follow one of these documents to get a proper environment:

* [Playing with Minikube](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-Minikube.md)
* [Playing with Azure Kubernetes Service (AKS)](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-AKS.md)

```text
$ kubectl version --short
Client Version: v1.18.8
Server Version: v1.17.11
```

## Install the OSM CLI

1\. Download platform specific compressed package from the [Releases page](https://github.com/openservicemesh/osm/releases):

```text
$ wget https://github.com/openservicemesh/osm/releases/download/v0.4.0/osm-v0.4.0-linux-amd64.tar.gz
...
2020-09-25 06:55:19 (13.5 MB/s) - ‘osm-v0.4.0-linux-amd64.tar.gz’ saved [11497510/11497510]
```

2\. Unpack the `osm` binary:

```text
$ tar -xzf osm-v0.4.0-linux-amd64.tar.gz
$ cd linux-amd64/
$ ls
LICENSE  README.md  osm
```

3\. Add the OSM CLI to your `$PATH`:

```text
$ export PATH="$HOME/linux-amd64:$PATH"
$ osm version
Version: v0.4.0; Commit: 69d1d54fe4cf5883ad72852e3ceaf5efbbe959f1; Date: 2020-09-24-20:36
```

## Install OSM

1\. Install the OSM control plane on to the Kubernetes cluster:

```text
$ osm install
OSM installed successfully in namespace [osm-system] with mesh name [osm]
```

2\. Verify the installation of OSM:

```text
$ kubectl get pods --namespace osm-system
NAME                              READY   STATUS    RESTARTS   AGE
jaeger-6864b858c5-vr9fd           1/1     Running   0          22s
osm-controller-786b7d8bf8-dv4pw   1/1     Running   0          22s
osm-prometheus-6cdf59c56f-9kqsw   1/1     Running   0          22s
```

## Install and Run the Demo

1\. Deploy the demonstration with Kubernetes manifests:

```text
$ kubectl apply -f k8s.yaml
namespace/demo created
serviceaccount/service-a created
deployment.apps/service-a-v1-0-0-deployment created
service/acme-api created
serviceaccount/client-x created
deployment.apps/client-x-v1-0-0-deployment created
```

```text
$ kubectl get pods -n demo
NAME                                           READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-797b4fc7bb-kwfqh    1/1     Running   0          19s
service-a-v1-0-0-deployment-75bfb499bb-jc6fk   1/1     Running   0          19s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-kwfqh -n demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
```

## Onboard Services into the Mesh

```text
$ osm namespace add demo --enable-sidecar-injection
Namespace [demo] successfully added to mesh [osm]
```

```text
$ osm namespace list
NAMESPACE   MESH   SIDECAR-INJECTION   
demo        osm    enabled
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-kwfqh -n demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
...
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-jc6fk
```

```text
$ kubectl delete pods --all -n demo
pod "client-x-v1-0-0-deployment-797b4fc7bb-kwfqh" deleted
pod "service-a-v1-0-0-deployment-75bfb499bb-jc6fk" deleted
```

```text
$ kubectl get pods -n demo
NAME                                           READY   STATUS    RESTARTS   AGE
client-x-v1-0-0-deployment-797b4fc7bb-9zw4g    2/2     Running   0          9m37s
service-a-v1-0-0-deployment-75bfb499bb-fmb8r   2/2     Running   0          9m37s
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-9zw4g client-x -n demo | tail
[INFO] get /path-01 | 000
[INFO] get /path-01 | 000
[INFO] get /path-01 | 000
...
[INFO] get /path-01 | 000
[INFO] get /path-01 | 000
```

```text
$ kubectl apply -f k8s-for-osm-bug.yaml
service/client-x-v1-0-0 created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-9zw4g client-x -n demo | tail
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
...
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
```

## Allow Traffic with SMI `TrafficTarget`

### Level 4

```yaml
# traffic.L4.yaml
---
#TCPRoute: tcp-route
apiVersion: specs.smi-spec.io/v1alpha3
kind: TCPRoute
metadata:
  name: tcp-route
  namespace: demo
spec: {}
---
# TrafficTarget: allow-client-x-to-service-a
kind: TrafficTarget
apiVersion: access.smi-spec.io/v1alpha2
metadata:
  name: allow-client-x-to-service-a
  namespace: demo
spec:
  destination:
    kind: ServiceAccount
    name: service-a
    namespace: demo
    port: 3000
  rules:
  - kind: TCPRoute
    name: tcp-route
  sources:
  - kind: ServiceAccount
    name: client-x
    namespace: demo
```

```text
$ kubectl apply -f traffic.L4.yaml
tcproute.specs.smi-spec.io/tcp-route created
traffictarget.access.smi-spec.io/allow-client-x-to-service-a created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-9zw4g client-x -n demo | tail
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
...
[INFO] get /path-01 | 404
[INFO] get /path-01 | 404
```

> **_WARNING:_** OSM does not support yet `TCPRoute`, see [Issue #1521](https://github.com/openservicemesh/osm/issues/1521).

### Level 7

```yaml
# traffic.L7.yaml
---
# HTTPRouteGroup: alpha-api-routes
apiVersion: specs.smi-spec.io/v1alpha3
kind: HTTPRouteGroup
metadata:
  name: alpha-api-routes
  namespace: demo
spec:
  matches:
  - name: get-path-01
    pathRegex: /path-01
    methods:
    - GET
---
# TrafficTarget: allow-client-x-to-service-a-through-alpha-api-routes
kind: TrafficTarget
apiVersion: access.smi-spec.io/v1alpha2
metadata:
  name: allow-client-x-to-service-a-through-alpha-api-routes
  namespace: demo
spec:
  destination:
    kind: ServiceAccount
    name: service-a
    namespace: demo
    port: 3000
  rules:
  - kind: HTTPRouteGroup
    name: alpha-api-routes
    matches:
    - get-path-01
  sources:
  - kind: ServiceAccount
    name: client-x
    namespace: demo
```

```text
$ kubectl apply -f traffic.L7.yaml
httproutegroup.specs.smi-spec.io/alpha-api-routes created
traffictarget.access.smi-spec.io/allow-client-x-to-service-a-through-alpha-api-routes created
```

```text
$ kubectl logs client-x-v1-0-0-deployment-797b4fc7bb-9zw4g client-x -n demo | tail
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
[INFO] get /path-01 | Hello from get /path-01! | service-a (1.0.0) | service-a-v1-0-0-deployment-75bfb499bb-fmb8r
```

## References

<https://openservicemesh.io/>

<https://github.com/openservicemesh/osm>

<https://github.com/openservicemesh/osm/blob/main/docs/installation_guide.md>

<https://github.com/openservicemesh/osm/blob/main/docs/example/README.md>

<https://github.com/openservicemesh/osm/blob/main/DESIGN.md>

<https://groups.google.com/g/openservicemesh/c/KdprhUJvKUE>

<https://github.com/openservicemesh/osm/issues/1521>

<https://github.com/openservicemesh/osm/issues/1524>
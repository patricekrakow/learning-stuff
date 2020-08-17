# Playing with Microsoft Open Service Mesh (OSM)

## Prerequisite(s)

You must have a running _Kubernetes_ cluster, and an access to it via the `kubectl` CLI. You can follow one of these documents to get a proper environment:
* [Playing with Minikube](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-Minikube.md)
* [Playing with Azure Kubernetes Service (AKS)](https://github.com/patricekrakow/learning-stuff/blob/master/playing-with-AKS.md)

```
$ kubectl version --short
```
<details><summary>Output the command</summary>

```
Client Version: v1.16.0
Server Version: v1.16.13
```
</details>

## Install the OSM CLI

1\. Download platform specific compressed package from the [Releases page](https://github.com/openservicemesh/osm/releases) using the following command:
```
$ wget https://github.com/openservicemesh/osm/releases/download/v0.3.0/osm-v0.3.0-linux-amd64.tar.gz
```
<details><summary>Output the command</summary>

```
--2020-08-13 18:54:05--  https://github.com/openservicemesh/osm/releases/download/v0.3.0/osm-v0.3.0-linux-amd64.tar.gz
Resolving github.com (github.com)... 140.82.118.4
Connecting to github.com (github.com)|140.82.118.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/227895834/2e900280-dce6-11ea-815f-189771af1afa?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200813%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200813T185406Z&X-Amz-Expires=300&X-Amz-Signature=e72d1b482c53915fe46cbdeab76bbecfd7ca30f8a51702dfb6916a2e7d89f3c7&X-Amz-SignedHeaders=host&actor_id=0&repo_id=227895834&response-content-disposition=attachment%3B%20filename%3Dosm-v0.3.0-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2020-08-13 18:54:06--  https://github-production-release-asset-2e65be.s3.amazonaws.com/227895834/2e900280-dce6-11ea-815f-189771af1afa?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200813%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200813T185406Z&X-Amz-Expires=300&X-Amz-Signature=e72d1b482c53915fe46cbdeab76bbecfd7ca30f8a51702dfb6916a2e7d89f3c7&X-Amz-SignedHeaders=host&actor_id=0&repo_id=227895834&response-content-disposition=attachment%3B%20filename%3Dosm-v0.3.0-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.25.92
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.25.92|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22543737 (21M) [application/octet-stream]
Saving to: ‘osm-v0.3.0-linux-amd64.tar.gz’

osm-v0.3.0-linux-amd64.tar.gz        100%[===================================================================>]  21.50M  18.3MB/s    in 1.2s

2020-08-13 18:54:07 (18.3 MB/s) - ‘osm-v0.3.0-linux-amd64.tar.gz’ saved [22543737/22543737]
```
</details>

2\. Unpack the `osm` binary using the following command:

```
$ tar -xzf osm-v0.3.0-linux-amd64.tar.gz
$ cd linux-amd64/
$ ls
```
<details><summary>Output the command</summary>

```
LICENSE  osm  README.md
```
</details>

3\. Add the OSM CLI to your path using the following command:
```
$ export PATH="$HOME/linux-amd64:$PATH"
$ osm version
```
<details><summary>Output the command</summary>

```
Version: v0.3.0; Commit: c91c782; Date: 2020-08-12-21:49
```
</details>

## Install OSM

1\. Install the OSM control plane on to the Kubernetes cluster using the following command:
```
$ osm install
```
<details><summary>Output the command</summary>

```
OSM installed successfully in namespace [osm-system] with mesh name [osm]
```
</details>

2\. Verify the installation of OSM using the following command:
```
$ kubectl get pods --namespace osm-system
```
<details><summary>Output the command</summary>

```
NAME                             READY   STATUS    RESTARTS   AGE
osm-controller-5778756dd-4tq88   1/1     Running   0          43s
osm-grafana-775c79f77-6d6x9      1/1     Running   0          43s
osm-prometheus-d54f6f8b7-m6g4f   1/1     Running   0          43s
zipkin-5dbc54795f-pnbmm          1/1     Running   0          43s
```
</details>

## Install the Demo

1\. Deploy the `service-a` using the following command:
```
$ kubectl apply -f https://raw.githubusercontent.com/patricekrakow/learning-microservices/master/demo/service-a~v1.0.0/service-a.yaml
```
> **_WARNING:_** OSM requires the `name` of the `Service` to match the value of the `app` label; it's a bug, see [Issue #1524](https://github.com/openservicemesh/osm/issues/1524).
<details><summary>Output the command</summary>

```
namespace/demo-01 created
serviceaccount/service-a created
service/service-a-service created
deployment.apps/service-a-deployment created
```
</details>

2\. Deploy the `client-x` using the following command:
```
$ kubectl apply -f https://raw.githubusercontent.com/patricekrakow/learning-microservices/master/demo/client-x~v1.0.0/client-x.yaml
```
> **_WARNING:_** OSM requires the `name` of the `Service` to match the value of the `app` label; it's a bug, see [Issue #1524](https://github.com/openservicemesh/osm/issues/1524).

<details><summary>Output the command</summary>

```
namespace/demo-01 unchanged
serviceaccount/client-x created
service/client-x-service created
deployment.apps/client-x-deployment created
```
</details>

```
$ kubectl get pods -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                                    READY   STATUS    RESTARTS   AGE
client-x-deployment-859f4b448f-8vwrw    1/1     Running   0          58s
service-a-deployment-5df87cc6bd-swz29   1/1     Running   0          117s
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-8vwrw -n demo-01 | tail
```
<details><summary>Output the command</summary>

```
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
...
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
```
</details>

## Onboard Services

```
$ osm namespace add demo-01
```
<details><summary>Output the command</summary>

```
Namespace [demo-01] succesfully added to mesh [osm]
```
</details>

```
$ kubectl get namespace demo-01 -o yaml
```
<details><summary>Output the command</summary>

```
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Namespace","metadata":{"annotations":{},"name":"demo-01"}}
  creationTimestamp: "2020-08-13T19:00:00Z"
  labels:
    openservicemesh.io/monitored-by: osm
  name: demo-01
  resourceVersion: "2616"
  selfLink: /api/v1/namespaces/demo-01
  uid: 67dc9e7f-9f0c-4e84-903b-b72d7a64c7c7
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-8vwrw -n demo-01 | tail
```
<details><summary>Output the command</summary>

```
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
...
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-swz29
```
</details>

```
$ kubectl delete pod client-x-deployment-859f4b448f-8vwrw -n demo-01
```
<details><summary>Output the command</summary>

```
pod "client-x-deployment-859f4b448f-8vwrw" deleted
```
</details>

```
$ kubectl delete pod service-a-deployment-5df87cc6bd-swz29 -n demo-01
```
<details><summary>Output the command</summary>

```
pod "service-a-deployment-5df87cc6bd-swz29" deleted
```
</details>

```
$ kubectl get pods -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                                    READY   STATUS    RESTARTS   AGE
client-x-deployment-859f4b448f-mh7f2    2/2     Running   0          117s
service-a-deployment-5df87cc6bd-cwq56   2/2     Running   0          67s
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-mh7f2 client-x -n demo-01 | tail
```
<details><summary>Output the command</summary>

```
[INFO]
[INFO]
[INFO]
[INFO]
...
[INFO]
[INFO]
```
</details>

## Allow Traffic with SMI

### Level 4

```yaml
# traffic.L4.yaml
---
# Deploy the 'tcp-route' TCPRoute
apiVersion: specs.smi-spec.io/v1alpha3
kind: TCPRoute
metadata:
  name: tcp-route
  namespace: demo-01
spec: {}
---
# Deploy the 'allow-client-x-to-service-a' TrafficTarget
kind: TrafficTarget
apiVersion: access.smi-spec.io/v1alpha2
metadata:
  name: allow-client-x-to-service-a
  namespace: demo-01
spec:
  destination:
    kind: ServiceAccount
    name: service-a
    namespace: demo-01
    port: 3000
  rules:
  - kind: TCPRoute
    name: tcp-route
  sources:
  - kind: ServiceAccount
    name: client-x
    namespace: demo-01
```

> **_WARNING:_** OSM does not support yet `TCPRoute`, see [Issue #1521](https://github.com/openservicemesh/osm/issues/1521).

```
$ kubectl apply -f traffic.L4.yaml
```
<details><summary>Output the command</summary>

```
tcproute.specs.smi-spec.io/tcp-route created
traffictarget.access.smi-spec.io/allow-client-x-to-service-a created
```
</details>

```
$ kubectl get TCPRoute -n demo-01
```
<details><summary>Output the command</summary>

```
NAME        AGE
tcp-route   138m
```
</details>

```
$ kubectl get TrafficTarget -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                          AGE
allow-client-x-to-service-a   136m
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-mh7f2 client-x -n demo-01 | tail
```
<details><summary>Output the command</summary>

> **_WARNING:_** OSM does not support yet `TCPRoute`, see [Issue #1521](https://github.com/openservicemesh/osm/issues/335).
```
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
[INFO]
```
</details>

### Level 7

```yaml
# traffic.L7.yaml
---
# Deploy the 'service-a-routes' HTTPRouteGroup
apiVersion: specs.smi-spec.io/v1alpha3
kind: HTTPRouteGroup
metadata:
  name: service-a-routes
  namespace: demo-01
spec:
  matches:
  - name: get-path-01
    pathRegex: /path-01
    methods:
    - GET
  - name: get-path-02
    pathRegex: /path-02
    methods:
    - GET
---
# Deploy the 'allow-client-x-to-service-a' TrafficTarget
kind: TrafficTarget
apiVersion: access.smi-spec.io/v1alpha2
metadata:
  name: allow-client-x-to-service-a
  namespace: demo-01
spec:
  destination:
    kind: ServiceAccount
    name: service-a
    namespace: demo-01
    port: 3000
  rules:
  - kind: HTTPRouteGroup
    name: service-a-routes
    matches:
    - get-path-01
    - get-path-02
  sources:
  - kind: ServiceAccount
    name: client-x
    namespace: demo-01
```

```
$ kubectl apply -f traffic.L7.yaml
```
or
```
$ kubectl apply -f https://raw.githubusercontent.com/patricekrakow/learning-stuff/master/playing-with-OSM/traffic.L7.yaml
```
<details><summary>Output the command</summary>

```
httproutegroup.specs.smi-spec.io/service-a-routes created
traffictarget.access.smi-spec.io/allow-client-x-to-service-a created
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-mh7f2 client-x -n demo-01 | tail
```
<details><summary>Output the command</summary>

```
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
...
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-5df87cc6bd-q8n7p
```
</details>

## References

<https://openservicemesh.io/>

<https://github.com/openservicemesh/osm>

<https://github.com/openservicemesh/osm/blob/main/docs/installation_guide.md>

<https://github.com/openservicemesh/osm/blob/main/docs/example/README.md>

<https://github.com/openservicemesh/osm/blob/main/DESIGN.md>

<https://groups.google.com/g/openservicemesh/c/KdprhUJvKUE>

<https://github.com/openservicemesh/osm/issues/1521>

<https://github.com/openservicemesh/osm/issues/1524>
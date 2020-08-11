# Playing with Microsoft Open Service Mesh (OSM)

## Set up the OSM CLI

1\. Download platform specific compressed package from the [Releases page](https://github.com/openservicemesh/osm/releases) using the following command:
```
$ wget https://github.com/openservicemesh/osm/releases/download/v0.2.0/osm-v0.2.0-linux-amd64.tar.gz
```
<details><summary>Output the command</summary>

```
--2020-08-10 09:02:52--  https://github.com/openservicemesh/osm/releases/download/v0.2.0/osm-v0.2.0-linux-amd64.tar.gz
Resolving github.com (github.com)... 192.30.255.112
Connecting to github.com (github.com)|192.30.255.112|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/227895834/29304500-d81a-11ea-84b8-6a3aca3de7c6?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200810%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200810T090252Z&X-Amz-Expires=300&X-Amz-Signature=20cf4d08211612ac8b45b9569a0a51d0ae125426f97280911d0f2b032e55fac6&X-Amz-SignedHeaders=host&actor_id=0&repo_id=227895834&response-content-disposition=attachment%3B%20filename%3Dosm-v0.2.0-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2020-08-10 09:02:52--  https://github-production-release-asset-2e65be.s3.amazonaws.com/227895834/29304500-d81a-11ea-84b8-6a3aca3de7c6?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200810%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200810T090252Z&X-Amz-Expires=300&X-Amz-Signature=20cf4d08211612ac8b45b9569a0a51d0ae125426f97280911d0f2b032e55fac6&X-Amz-SignedHeaders=host&actor_id=0&repo_id=227895834&response-content-disposition=attachment%3B%20filename%3Dosm-v0.2.0-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.227.176
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.227.176|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22553127 (22M) [application/octet-stream]
Saving to: ‘osm-v0.2.0-linux-amd64.tar.gz’

osm-v0.2.0-linux-amd64.tar.gz        100%[===================================================================>]  21.51M  20.7MB/s    in 1.0s

2020-08-10 09:02:54 (20.7 MB/s) - ‘osm-v0.2.0-linux-amd64.tar.gz’ saved [22553127/22553127]
```
</details>

2\. Unpack the `osm` binary using the following command:

```
$ tar -xzf osm-v0.2.0-linux-amd64.tar.gz
$ cd linux-amd64/
$ ls
```
<details><summary>Output the command</summary>

```
LICENSE  osm  README.md
```
</details>

3\. Add the `osm` binary to `$PATH` using the following command:
```
$ export PATH="$HOME/linux-amd64:$PATH"
$ osm version
```
<details><summary>Output the command</summary>

```
Version: v0.2.0; Commit: 3ec26b3; Date: 2020-08-06-19:19
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
NAME                              READY   STATUS    RESTARTS   AGE
osm-controller-57f9bdff7c-g8s2p   1/1     Running   0          5m31s
osm-grafana-775c79f77-vm9sh       1/1     Running   0          5m31s
osm-prometheus-d54f6f8b7-xnwhf    1/1     Running   0          5m31s
zipkin-5dbc54795f-8ngvk           1/1     Running   0          5m31s
```
</details>

## Install the Demo

1\. Deploy the `service-a` using the following command:
```
$ kubectl apply -f https://raw.githubusercontent.com/patricekrakow/learning-microservices/master/demo/service-a~v1.0.0/service-a.yaml
```
<details><summary>Output the command</summary>

```
...
```
</details>

2\. Deploy the `client-x` using the following command:
```
$ kubectl apply -f https://raw.githubusercontent.com/patricekrakow/learning-microservices/master/demo/client-x~v1.0.0/client-x.yaml
```
<details><summary>Output the command</summary>

```
...
```
</details>

```
$ kubectl get pods -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                                   READY   STATUS    RESTARTS   AGE
client-x-deployment-59f9767657-g7vhc   1/1     Running   0          8m23s
service-a-deployment-66d47877b-vhdxb   1/1     Running   0          44m
```
</details>

```
$ kubectl logs client-x-deployment-59f9767657-g7vhc -n demo-01
```
<details><summary>Output the command</summary>

```
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
...
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
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
  creationTimestamp: "2020-08-11T15:07:43Z"
  labels:
    openservicemesh.io/monitored-by: osm
  name: demo-01
  resourceVersion: "167551"
  selfLink: /api/v1/namespaces/demo-01
  uid: 2f360ec1-74fa-49b7-8bd3-72bb2145380e
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```
</details>

```
$ kubectl delete pod service-a-deployment-66d47877b-vhdxb -n demo-01
```
<details><summary>Output the command</summary>

```
pod "service-a-deployment-66d47877b-vhdxb" deleted
```
</details>

```
$ kubectl get pods -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                                   READY   STATUS    RESTARTS   AGE
client-x-deployment-59f9767657-g7vhc   1/1     Running   0          12m
service-a-deployment-66d47877b-s7m2v   2/2     Running   0          17s
```
</details>

```
$ kubectl logs client-x-deployment-59f9767657-g7vhc -n demo-01
```
<details><summary>Output the command</summary>

```
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
...
[INFO] Hello from get /path-01 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO] Hello from get /path-02 | service-a (1.0.0) | service-a-deployment-66d47877b-vhdxb
[INFO]
[INFO]
...
[INFO]
```
</details>

```
$ kubectl delete pod client-x-deployment-59f9767657-g7vhc -n demo-01
```
<details><summary>Output the command</summary>

```
pod "client-x-deployment-59f9767657-g7vhc" deleted
```
</details>

```
$ kubectl get pods -n demo-01
```
<details><summary>Output the command</summary>

```
NAME                                    READY   STATUS    RESTARTS   AGE
client-x-deployment-6dc67f6bdf-g7rgn    2/2     Running   0          4s
service-a-deployment-5df87cc6bd-txknm   2/2     Running   0          49s
```
</details>

```
$ kubectl logs client-x-deployment-6dc67f6bdf-g7rgn client-x -n demo-01 | tail
```
<details><summary>Output the command</summary>

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

## Allow Traffic with SMI

### Level 4

```yaml
# traffic.yaml
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

### Level 7

## References

<https://openservicemesh.io/>

<https://github.com/openservicemesh/osm>

<https://github.com/openservicemesh/osm/blob/main/docs/installation_guide.md>

<https://github.com/openservicemesh/osm/blob/main/docs/example/README.md>

<https://github.com/openservicemesh/osm/blob/main/DESIGN.md>


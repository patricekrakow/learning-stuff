# Playing with Containous Maesh

## Prerequisites

## Install and Test the Demo

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

3\. Get the names of the pods using the following command:

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

\4. Get the logs of `client-x` to check that `service-a` is properly responding:

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

## Install Maesh

```
$ helm repo add maesh https://containous.github.io/maesh/charts
```
<details><summary>Output the command</summary>

```
"maesh" has been added to your repositories
```
</details>

```
$ helm repo update
```
<details><summary>Output the command</summary>

```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "maesh" chart repository
Update Complete. ⎈ Happy Helming!⎈
```
</details>

```
$ kubectl create namespace maesh
$ helm install maesh maesh/maesh --set acl=true
```

If we change the `client-x.yaml` manifest to use `service-a.demo-01.maesh` instead `service-a.demo-01` as the (network) name for `service-a`, then the traffic between `client-x` and `service-a` is blocked because there is no authorization/access defined.

```
$ kubectl logs client-x-deployment-859f4b448f-8vwrw -n demo-01 | tail
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

```yaml
# traffic.yaml
---
# Deploy the 'service-a-routes' HTTPRouteGroup
apiVersion: specs.smi-spec.io/v1alpha1
kind: HTTPRouteGroup
metadata:
  name: service-a-routes
  namespace: demo-01
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
apiVersion: access.smi-spec.io/v1alpha1
metadata:
  name: allow-client-x-to-service-a
  namespace: demo-01
destination:
  kind: ServiceAccount
  name: service-a
  namespace: demo-01
  port: 3000
specs:
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
$ kubectl apply -f traffic.yaml
```
<details><summary>Output the command</summary>

```
httproutegroup.specs.smi-spec.io/service-a-routes configured
traffictarget.access.smi-spec.io/allow-client-x-to-service-a unchanged
```
</details>

```
$ kubectl logs client-x-deployment-859f4b448f-8vwrw -n demo-01 | tail
```
<details><summary>Output the command</summary>

_**It does not work :-(**_
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
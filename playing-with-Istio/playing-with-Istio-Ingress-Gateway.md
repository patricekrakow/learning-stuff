# Playing with Istio Ingress Gateway

## Prerequisites

```text
$ kubectl get pods -n istio-system
NAME                                   READY   STATUS    RESTARTS   AGE
istio-ingressgateway-5689f7c67-2z2pw   1/1     Running   0          4m58s
istiod-5c6b7b5b8f-45mhq                1/1     Running   0          5m14s
```

```text
$ kubectl get services -n istio-system
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                                                      AGE
istio-ingressgateway   LoadBalancer   10.0.215.195   51.105.105.115   15021:30112/TCP,80:31005/TCP,443:32270/TCP,15443:31406/TCP   5m23s
istiod                 ClusterIP      10.0.60.178    <none>           15010/TCP,15012/TCP,443/TCP,15014/TCP,853/TCP                5m39s
```

## Install and Run the Demo

```text
$ kubectl label namespace default istio-injection=enabled
namespace/default labeled
```

```text
$ git clone https://github.com/istio/istio.git
Cloning into 'istio'...
... done.
$ cd istio
```

```text
$ kubectl apply -f samples/httpbin/httpbin.yaml
serviceaccount/httpbin created
service/httpbin created
deployment.apps/httpbin created
```

```text
$ kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
httpbin-779c54bf49-r9b9z   2/2     Running   0          40s
```

```text
$ kubectl get services
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
httpbin      ClusterIP   10.0.178.48   <none>        8000/TCP   98s
kubernetes   ClusterIP   10.0.0.1      <none>        443/TCP    12m
```

```text
$ kubectl get service istio-ingressgateway -n istio-system
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)   AGE
istio-ingressgateway   LoadBalancer   10.0.215.195   51.105.105.115   ...       8m14s
```

```text
$ kubectl apply -f gateway.istio.yaml 
gateway.networking.istio.io/httpbin-gateway created
virtualservice.networking.istio.io/httpbin created
```

```text
$ curl --silent --head --header "Host: httpbin.example.com" http://51.105.105.115:80/status/200
HTTP/1.1 200 OK
server: istio-envoy
date: Tue, 06 Oct 2020 09:31:20 GMT
content-type: text/html; charset=utf-8
access-control-allow-origin: *
access-control-allow-credentials: true
content-length: 0
x-envoy-upstream-service-time: 2
```

## Call from a VM

```text
$ az vm create \
  --resource-group group-01 \
  --name vm-01 \
  --image UbuntuLTS \
  --admin-username radicel \
  --generate-ssh-keys
$ ssh radicel@<PublicIPAddress>
radicel@vm-01:~$ curl --silent --head --header "Host: httpbin.example.com" http://51.105.105.115:80/status/200
HTTP/1.1 200 OK
server: istio-envoy
date: Tue, 06 Oct 2020 10:32:43 GMT
content-type: text/html; charset=utf-8
access-control-allow-origin: *
access-control-allow-credentials: true
content-length: 0
x-envoy-upstream-service-time: 3
```

## Reference

<https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/>

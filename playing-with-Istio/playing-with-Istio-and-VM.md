# Playing with Istio and VM

```text
$ az vm create \
  --resource-group group-01 \
  --name vm-01 \
  --image UbuntuLTS \
  --admin-username radicel \
  --generate-ssh-keys
$ ssh radicel@<PublicIPAddress>
radicel@vm-01:~$ exit
```

```text
$ export VM_NAME="vm-01"
$ export VM_NAMESPACE="istio-demo"
$ export WORK_DIR="work"
$ export SERVICE_ACCOUNT="client-x"
$ echo $VM_NAME $VM_NAMESPACE $WORK_DIR $SERVICE_ACCOUNT
vm-01 istio-demo work client-x
```

```text
$ tokenexpiretime=3600
$ echo '{"kind":"TokenRequest","apiVersion":"authentication.k8s.io/v1","spec":{"audiences":["istio-ca"],"expirationSeconds":'$tokenexpiretime'}}' | kubectl create --raw /api/v1/namespaces/$VM_NAMESPACE/serviceaccounts/$SERVICE_ACCOUNT/token -f - | jq -j '.status.token' > "${WORK_DIR}"/istio-token
$ ls $WORK_DIR
istio-token
```

```text
$ kubectl -n "${VM_NAMESPACE}" get configmaps istio-ca-root-cert -o json | jq -j '."data"."root-cert.pem"' > "${WORK_DIR}"/root-cert.pem
$ ls $WORK_DIR
istio-token  root-cert.pem
```

```text
$ ISTIO_SERVICE_CIDR=$(echo '{"apiVersion":"v1","kind":"Service","metadata":{"name":"tst"},"spec":{"clusterIP":"1.1.1.1","ports":[{"port":443}]}}' | kubectl apply -f - 2>&1 | sed 's/.*valid IPs is //')
$ touch "${WORK_DIR}"/cluster.env
$ echo ISTIO_SERVICE_CIDR=$ISTIO_SERVICE_CIDR > "${WORK_DIR}"/cluster.env
$ ls $WORK_DIR
cluster.env  istio-token  root-cert.pem
```

```text
$ export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
$ echo $INGRESS_HOST:$INGRESS_PORT
51.105.105.115:80
```

```text
$ touch "${WORK_DIR}"/hosts-addendum
$ echo "${INGRESS_HOST} istiod.istio-system.svc" > "${WORK_DIR}"/hosts-addendum
$ ls $WORK_DIR
cluster.env  hosts-addendum  istio-token  root-cert.pem
```

```text
$ touch "${WORK_DIR}"/sidecar.env
$ echo "PROV_CERT=/var/run/secrets/istio" >>"${WORK_DIR}"/sidecar.env
$ echo "OUTPUT_CERTS=/var/run/secrets/istio" >> "${WORK_DIR}"/sidecar.env
$ ls $WORK_DIR
cluster.env  hosts-addendum  istio-token  root-cert.pem  sidecar.env
```

```text
$ scp -r work/ radicel@51.137.207.100:/home/radicel/
istio-token                                        100% 1201    66.0KB/s   00:00
sidecar.env                                        100%   69     3.9KB/s   00:00
root-cert.pem                                      100% 1054    57.9KB/s   00:00
hosts-addendum                                     100%   39     2.2KB/s   00:00
cluster.env                                        100%   31     1.7KB/s   00:00
```

```text
$ ssh radicel@<PublicIPAddress>
radicel@vm-01:~$
```

```text
radicel@vm-01:~$ sudo apt -y update
radicel@vm-01:~$ sudo apt -y upgrade
```
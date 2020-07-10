# Playing with Minikube

<https://kubernetes.io/docs/tasks/tools/install-minikube/>

You need to have a machine that do support virtualization.

## Create a VM on Azure that do Support Virtualization

Let's first create a dedicated _resource group_ for all the _resources_ we will create; we will have more than just a _VM_.

```
user@Azure:~$ az group create --name group-01 --location francecentral
```

Then, we can create our _VM_:

```
user@Azure:~$ az vm create \
  --resource-group group-01 \
  --name minikube-01 \
  --image UbuntuLTS \
  --size Standard_D2s_v3 \
  --admin-username radicel \
  --generate-ssh-keys
```

Note the `publicIpAddress` that has been created for your _VM_, otherwise you can easily retrieve it using the following command:

```
user@Azure:~$ az vm list-ip-addresses -n minikube-01 -g group-01
```

Then, we should make the _VM_ accessible, this command will create quite a few _resources_.

```
user@Azure:~$ az vm open-port --port 80 --resource-group group-01 --name minikube-01
```

We can connect to our _VM_ and install NGINX to test the network connectivity.

```
user@Azure:~$ ssh radicel@publicIPAddress
radicel@minikube-01:~$ sudo apt-get -y update
radicel@minikube-01:~$ sudo apt-get -y install nginx
radicel@minikube-01:~$ exit
```

You can now test the connectivity by going to the `publicIPAddess` with your browser.

In order to save money, when you have finished, **do not forget** to delete all the _resources_ created by deleting the `group-01` _resource group_ you have created.

```
user@Azure:~$ az group delete --name group-01
```

You can check that your _VM_ is actually supporting virtualization by running the following command and verify that the output is non-empty:

```
user@Azure:~$ grep -E --color 'vmx|svm' /proc/cpuinfo
```
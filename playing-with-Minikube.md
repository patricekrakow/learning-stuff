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

## Install VirtualBox as Hypervisor

<https://www.virtualbox.org/wiki/Linux_Downloads>

First of all, you should get the version of Ubuntu with the following command:
```
radicel@minikube-01:~$ lsb_release -a
```

Add the following line to your `/etc/apt/sources.list` file.
```
deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian <mydist> contrib
```
where `<mydist>` should be replaced by replace with `eoan`, `bionic`, `xenial`, buster`, `stretch`, or `jessie` according to your version.

```
radicel@minikube-01:~$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
radicel@minikube-01:~$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
```

```
radicel@minikube-01:~$ sudo apt-get update
radicel@minikube-01:~$ sudo apt-get install virtualbox-6.1
```

## Install `kubectl`

```
radicel@minikube-01:~$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
radicel@minikube-01:~$ chmod +x ./kubectl
radicel@minikube-01:~$ sudo mv ./kubectl /usr/local/bin/kubectl
radicel@minikube-01:~$ kubectl version --client
```

## Install Minikube

<https://kubernetes.io/docs/tasks/tools/install-minikube/>

```
radicel@minikube-01:~$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
radicel@minikube-01:~$ chmod +x minikube
radicel@minikube-01:~$ sudo mkdir -p /usr/local/bin/
radicel@minikube-01:~$ sudo install minikube /usr/local/bin/
```

```
radicel@minikube-01:~$ minikube version
radicel@minikube-01:~$ minikube status
```

## Start Minikube

```
radicel@minikube-01:~$ minikube start --memory=16384 --cpus=4
```
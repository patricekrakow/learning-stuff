# Playing with Azure Kubernetes Service (AKS)

## TL;DR

If you have already created a Kubernetes cluster following this page, you can redo it quickly using the following commands (I have removed the one-off actions):

```text
$ az group create \
  --name patrice-group-01 \
  --location westeurope
$ az aks create \
  --resource-group patrice-group-01 \
  --name patrice-cluster-01 \
  --node-count 3 \
  --generate-ssh-keys
$ az aks get-credentials \
  --resource-group patrice-group-01 \
  --name patrice-cluster-01
$ kubectl version --short
$ kubectl get nodes
```

And, don't forget to save money by delete the cluster and all related cluster when you do not need them anymore.

```text
$ az group delete --name patrice-group-01 --yes
```

> **_WARNING:_** AKS creates other resource groups when creating the Kubernetes cluster, and you MUST also delete them to save money!

```text
$ az group delete --name MC_patrice-group-01_patrice-cluster-01_westeurope --yes
$ az group delete --name NetworkWatcherRG --yes
```

## Create a Kubernetes Cluster with AKS

1\. Either go to <https://shell.azure.com>, or use your local installation of the `az` CLI and login to Azure:

```text
$ az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ********* to authenticate.
```

2\. Check that you are using the _subscription_ you want to use:

```text
$ az account show | jq '.name'
"my-subscription"
```

3\. Choose the _location_ where you want to create your Kubernetes cluster. You can use the following command to get the list of available regions:

```text
$ az account list-locations | jq .[].name
"eastus"
"eastus2"
"southcentralus"
"westus2"
"australiaeast"
...
"westeurope"
...
```

4\. Create an Azure _resource group_ called `patrice-group-01` using the following command:

```text
$ az group create \
  --name patrice-group-01 \
  --location westeurope
{
  "id": "/subscriptions/99999999-9999-9999-9999-999999999999/resourceGroups/patrice-group-01",
  "location": "westeurope",
  "managedBy": null,
  "name": "patrice-group-01",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

eventually replacing the value `westeurope` by another value of your choice coming from the previous command.

5\. If needed, register _Microsoft.OperationsManagement_ and _Microsoft.OperationalInsights_ to your subscription.

First, let's check _Microsoft.OperationsManagement_ using the following command:

```text
$ az provider show -n Microsoft.OperationsManagement -o table
Namespace                       RegistrationPolicy    RegistrationState
------------------------------  --------------------  -------------------
Microsoft.OperationsManagement  RegistrationRequired  NotRegistered
```

If it shows (as above) that the _Microsoft.OperationsManagement_ is not registered on your subscription, you can register it using the following command:

```text
$ az provider register --namespace Microsoft.OperationsManagement
Registering is still on-going. You can monitor using 'az provider show -n Microsoft.OperationsManagement'
```

Second, let's check _Microsoft.OperationalInsights_ using the following command:

```text
$ az provider show -n Microsoft.OperationalInsights -o table
Namespace                      RegistrationPolicy    RegistrationState
-----------------------------  --------------------  -------------------
Microsoft.OperationalInsights  RegistrationRequired  NotRegistered
```

If it shows (as above) that the _Microsoft.OperationalInsights_ is not registered on your subscription, you can register it using the following command:

```text
$ az provider register --namespace Microsoft.OperationalInsights
Registering is still on-going. You can monitor using 'az provider show -n Microsoft.OperationalInsights'
```

6\. We can know actually create a Kubernetes cluster called `patrice-cluster-01`:

```text
$ az aks create \
  --resource-group patrice-group-01 \
  --name patrice-cluster-01 \
  --node-count 3 \
  --generate-ssh-keys
SSH key files '/home/patrice/.ssh/id_rsa' and '/home/patrice/.ssh/id_rsa.pub' have been generated under ~/.ssh to allow SSH access to the VM. If using machines without permanent storage like Azure Cloud Shell without an attached file share, back up your keys to a safe location
 - Running ..
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

## Connect to the Cluster

1\. Let's first verify that `kubectl` is properly installed:

```text
$ kubectl version --short
Client Version: v1.20.0
error: You must be logged in to the server (the server has asked for the client to provide credentials)
```

2\. Download credentials and configures the Kubernetes CLI to use them:

```text
$ az aks get-credentials --resource-group patrice-group-01 --name patrice-cluster-01
Merged "patrice-cluster-01" as current context in /home/patrice/.kube/config
```

3\. Verify the connection to the cluster:

```text
$ kubectl get nodes
NAME                                STATUS   ROLES   AGE     VERSION
aks-nodepool1-25932043-vmss000000   Ready    agent   2m58s   v1.18.10
aks-nodepool1-25932043-vmss000001   Ready    agent   2m53s   v1.18.10
aks-nodepool1-25932043-vmss000002   Ready    agent   2m47s   v1.18.10
```

## Delete the Cluster

1\. To avoid Azure charges, you should delete the cluster as soon as you don't need it anymore:

```text
$ az group delete --name patrice-group-01 --yes
```

> **_WARNING:_** AKS creates other resource groups when creating the Kubernetes cluster, and you MUST also delete them to save money!

```text
$ az group list | jq '.[].name'
"cloud-shell-storage-westeurope"
"patrice-group-01"
"NetworkWatcherRG"
```

```text
$ az group delete --name NetworkWatcherRG --yes
```

## References

<https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough>

<https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal#additional-considerations>

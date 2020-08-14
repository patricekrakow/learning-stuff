# Playing with Azure Kubernetes Service (AKS)

## TL;DR

If you have already created a Kubernetes cluster following this page, you can redo it quickly using the following commands (I have removed the one-off actions):

```
$ az group create --name group-01 --location westeurope
$ az aks create --resource-group group-01 --name cluster-01 --node-count 3 --enable-addons monitoring --generate-ssh-keys
$ az aks create --resource-group group-01 --name cluster-01 --node-count 3 --enable-addons monitoring --generate-ssh-keys
$ kubectl version --short
$ kubectl get nodes
```

And, don't forget to save money by delete the cluster and all related cluster when you do not need them anymore.
```
$ az group delete --name group-01 --yes
```

> **_WARNING:_** AKS might create other _resource groups_ when creating the Kubernetes cluster, you MUST also delete them to save money!

## Create a Kubernetes Cluster with AKS

1\. Go to <https://shell.azure.com>.

2\. Choose the _location_ where you want to create your Kubernetes cluster using the following command:

```
$ az account list-locations | jq .[].name
```
<details><summary>Output the command</summary>

```
"eastus"
"eastus2"
"southcentralus"
"westus2"
"australiaeast"
...
"francecentral"
...
```
</details>

3\. Create an Azure _resource group_ called `group-01` using the following command:

```
$ az group create --name group-01 --location westeurope
```
eventually replacing the value `westeurope` by another value of your choice coming from the previous command.
<details><summary>Output the command</summary>

```json
{
  "id": "/subscriptions/99999999-9999-9999-9999-999999999999/resourceGroups/group-01",
  "location": "westeurope",
  "managedBy": null,
  "name": "group-01",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
</details>

4\. If needed, register _Microsoft.OperationsManagement_ and _Microsoft.OperationalInsights_ to your subscription.

First, let's check _Microsoft.OperationsManagement_ using the following command:

```
$ az provider show -n Microsoft.OperationsManagement -o table
```
<details><summary>Output the command</summary>

```
Namespace                       RegistrationPolicy    RegistrationState
------------------------------  --------------------  -------------------
Microsoft.OperationsManagement  RegistrationRequired  NotRegistered
```
</details>

If it shows (as above) that the _Microsoft.OperationsManagement_ is not registered on your subscription, you can register it using the following command:

```
$ az provider register --namespace Microsoft.OperationsManagement
```
<details><summary>Output the command</summary>

```
Registering is still on-going. You can monitor using 'az provider show -n Microsoft.OperationsManagement'
```
</details>

Second, let's check _Microsoft.OperationalInsights_ using the following command:

```
$ az provider show -n Microsoft.OperationalInsights -o table
```
<details><summary>Output the command</summary>

```
Namespace                      RegistrationPolicy    RegistrationState
-----------------------------  --------------------  -------------------
Microsoft.OperationalInsights  RegistrationRequired  NotRegistered
```
</details>

If it shows (as above) that the _Microsoft.OperationalInsights_ is not registered on your subscription, you can register it using the following command:

```
$ az provider register --namespace Microsoft.OperationalInsights
```
<details><summary>Output the command</summary>

```
Registering is still on-going. You can monitor using 'az provider show -n Microsoft.OperationalInsights'
```
</details>

5\. We can know actually create a Kubernetes cluster called `cluster-01` using the following command:

```
$ az aks create --resource-group group-01 --name cluster-01 --node-count 3 --enable-addons monitoring --generate-ssh-keys
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

<details><summary>Output the command</summary>

```json
{
  "aadProfile": null,
  "addonProfiles": {
    "KubeDashboard": {
      "config": null,
      "enabled": true,
      "identity": null
    },
    "omsagent": {
      "config": {
        "logAnalyticsWorkspaceResourceID": "/subscriptions/99999999-9999-9999-9999-999999999999/resourcegroups/defaultresourcegroup-par/providers/microsoft.operationalinsights/workspaces/defaultworkspace-99999999-9999-9999-9999-999999999999-par"
      },
      "enabled": true,
      "identity": null
    }
  },
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "count": 3,
      "enableAutoScaling": null,
      "enableNodePublicIp": false,
      "maxCount": null,
      "maxPods": 110,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeLabels": {},
      "nodeTaints": null,
      "orchestratorVersion": "1.16.10",
      "osDiskSizeGb": 128,
      "osType": "Linux",
      "provisioningState": "Succeeded",
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "vmSize": "Standard_DS2_v2",
      "vnetSubnetId": null
    }
  ],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "diskEncryptionSetId": null,
  "dnsPrefix": "cluster-01-group-01-999999",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "fqdn": "cluster-01-group-01-999999-99999999.hcp.francecentral.azmk8s.io",
  "id": "/subscriptions/99999999-9999-9999-9999-999999999999/resourcegroups/group-01/providers/Microsoft.ContainerService/managedClusters/cluster-01",
  "identity": null,
  "identityProfile": null,
  "kubernetesVersion": "1.16.10",
  "linuxProfile": {
    "adminUsername": "azureuser",
    "ssh": {
      "publicKeys": [
        {
          "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSkT3A1j89RT/540ghIMHXIVwNlAEM3WtmqVG7YN/wYwtsJ8iCszg4/lXQsfLFxYmEVe8L9atgtMGCi5QdYPl4X/c+5YxFfm88Yjfx+2xEgUdOr864eaI22yaNMQ0AlyilmK+PcSyxKP4dzkf6B5Nsw8lhfB5n9F5md6GHLLjOGuBbHYlesKJKnt2cMzzS90BdRk73qW6wJ+MCUWo+cyBFZVGOzrjJGEcHewOCbVs+IJWBFSi6w1enbKGc+RY9KrnzeDKWWqzYnNofiHGVFAuMxrmZOasqlTIKiC2UK3RmLxZicWiQmPnpnjJRo7pL0oYM9r/sIWzD6i2S9szDy6aZ"
        }
      ]
    }
  },
  "location": "francecentral",
  "maxAgentPools": 10,
  "name": "cluster-01",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIps": [
        {
          "id": "/subscriptions/99999999-9999-9999-9999-999999999999/resourceGroups/MC_group-01_cluster-01_francecentral/providers/Microsoft.Network/publicIPAddresses/99999999-9999-9999-9999-999999999999",
          "resourceGroup": "MC_group-01_cluster-01_francecentral"
        }
      ],
      "idleTimeoutInMinutes": null,
      "managedOutboundIps": {
        "count": 1
      },
      "outboundIpPrefixes": null,
      "outboundIps": null
    },
    "loadBalancerSku": "Standard",
    "networkMode": null,
    "networkPlugin": "kubenet",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": "10.244.0.0/16",
    "serviceCidr": "10.0.0.0/16"
  },
  "nodeResourceGroup": "MC_group-01_cluster-01_francecentral",
  "privateFqdn": null,
  "provisioningState": "Succeeded",
  "resourceGroup": "group-01",
  "servicePrincipalProfile": {
    "clientId": "99999999-9999-9999-9999-999999999999",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": null
}
```
</details>

## Connect to the Cluster

1\. Let's first verify that `kubectl` is properly installed using the following command:

```
$ kubectl version --short
```
<details><summary>Output the command</summary>

```
Client Version: v1.16.0
error: You must be logged in to the server (the server has asked for the client to provide credentials)
```
</details>

2\. Download credentials and configures the Kubernetes CLI to use them with the following command:
```
$ az aks get-credentials --resource-group group-01 --name cluster-01
```
<details><summary>Output the command</summary>

```
Merged "cluster-01" as current context in /home/patrice/.kube/config
```
</details>

3\. Verify the connection to the cluster using the following command:
```
$ kubectl get nodes
```
<details><summary>Output the command</summary>

```
NAME                                STATUS   ROLES   AGE   VERSION
aks-nodepool1-14300836-vmss000000   Ready    agent   22m   v1.16.10
aks-nodepool1-14300836-vmss000001   Ready    agent   21m   v1.16.10
aks-nodepool1-14300836-vmss000002   Ready    agent   22m   v1.16.10
```
</details>

## Delete the Cluster

1\. To avoid Azure charges, you should delete the cluster as soon as you don't need it anymore using the following command:
```
$ az group delete --name group-01 --yes
```

## References

<https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough>

<https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal#additional-considerations>

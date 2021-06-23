# Playing with Kubernetes CustomResourceDefinitions (CRDs)

## Prerequisites

You need to have a running Kubernetes cluster with an access to it via the `kubectl` CLI to be able the run the demo. If you don't have one, you can easily use the following Katacoda Scenario: <https://www.katacoda.com/patrice1972/scenarios/hello-world>. Just click on the _START SCENARIO_ button and type the following command:

```text
$ launch.sh
Waiting for Kubernetes to start...
Kubernetes started
```

You can eventually verify the installation with the following command:

```text
$ kubectl version --short
Client Version: v1.18.0
Server Version: v1.18.0
```

And finally, you can install the demo with the following commands:

```text
$ git clone https://github.com/patricekrakow/learning-stuff.git
Cloning into 'learning-stuff'...
remote: Enumerating objects: 137, done.
remote: Counting objects: 100% (137/137), done.
remote: Compressing objects: 100% (103/103), done.
remote: Total 137 (delta 72), reused 86 (delta 32), pack-reused 0
Receiving objects: 100% (137/137), 35.95 KiB | 566.00 KiB/s, done.
Resolving deltas: 100% (72/72), done.
$ cd learning-stuff/playing-with-Kubernetes-CRD/
```

**_Remark_**. I will, of course, soon propose/automate these steps via the Katacoda scenario.

## Demo

_Custom resources_ are extensions of the Kubernetes API.

Let's define a new _resource_ called `Thingy`. A `Thingy` _object_ will have two properties: `name` and `value`.

```yaml
# thingy-crd.yaml
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  # name must match the spec fields below, and be in the form: <plural>.<group>
  name: thingies.stable.patricelabs.io
spec:
  # group name to use for REST API: /apis/<group>/<version>
  group: stable.patricelabs.io
  # list of versions supported by this CustomResourceDefinition
  versions:
    - name: v1
      # Each version can be enabled/disabled by Served flag.
      served: true
      # One and only one version must be marked as the storage version.
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                name:
                  type: string
                value:
                  type: string
  # either Namespaced or Cluster
  scope: Namespaced
  names:
    # plural name to be used in the URL: /apis/<group>/<version>/<plural>
    plural: thingies
    # singular name to be used as an alias on the CLI and for display
    singular: thingy
    # kind is normally the CamelCased singular type. Your resource manifests use this.
    kind: Thingy
    # shortNames allow shorter string to match your resource on the CLI
    shortNames:
    - th

```

```text
$ kubectl apply -f thingy-crd.yaml
customresourcedefinition.apiextensions.k8s.io/thingies.stable.patricelabs.io created
```

```yaml
# my-1st-thingy.yaml
---
apiVersion: "stable.patricelabs.io/v1"
kind: Thingy
metadata:
  name: my-1st-thingy
spec:
  name: message
  value: Hello World!
```

```text
$ kubectl apply -f my-1st-thingy.yaml
thingy.stable.patricelabs.io/my-1st-thingy created
```

```text
$ kubectl get thingies
NAME            AGE
my-1st-thingy   30s
```

```text
$ kubectl describe thingy my-1st-thingy
Name:         my-1st-thingy
Namespace:    default
Labels:       <none>
Annotations:  API Version:  stable.patricelabs.io/v1
Kind:         Thingy
Metadata:
  Creation Timestamp:  2020-09-02T10:16:27Z
  Generation:          1
  Resource Version:    1615
  Self Link:           /apis/stable.patricelabs.io/v1/namespaces/default/thingies/my-1st-thingy
  UID:                 cfb81060-a62b-4d10-a224-b0df9c0c9d7b
Spec:
  Colour:  red
  Name:   message
  Value:  Hello World!
Events:   <none>
```

## References

<https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/>

<https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/>

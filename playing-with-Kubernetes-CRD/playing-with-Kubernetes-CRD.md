# Playing with Kubernetes CustomResourceDefinitions (CRDs)

_Custom resources_ are extensions of the Kubernetes API.

Let's define a new _resource_ called `Thingy`. A `Thingy` _object_ will have two properties: `name` and `value`.

```yaml
# thingy-crd.yaml
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  # name must match the spec fields below, and be in the form: <plural>.<group>
  name: thingies.stable.patricelabs.com
spec:
  # group name to use for REST API: /apis/<group>/<version>
  group: stable.patricelabs.com
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
customresourcedefinition.apiextensions.k8s.io/thingies.stable.patricelabs.com created
```

```yaml
# my-1st-thingy.yaml
---
apiVersion: "stable.patricelabs.com/v1"
kind: Thingy
metadata:
  name: my-1st-thingy
spec:
  name: message
  value: Hello World!
```

```text
$ kubectl apply -f my-1st-thingy.yaml
thingy.stable.patricelabs.com/my-1st-thingy created
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
Annotations:  API Version:  stable.patricelabs.com/v1
Kind:         Thingy
Metadata:
  Creation Timestamp:  2020-09-02T10:16:27Z
  Generation:          1
  Resource Version:    1615
  Self Link:           /apis/stable.patricelabs.com/v1/namespaces/default/thingies/my-1st-thingy
  UID:                 cfb81060-a62b-4d10-a224-b0df9c0c9d7b
Spec:
  Name:   message
  Value:  Hello World!
Events:   <none>
```

## References

<https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/>

<https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/>
# Playing with Kubernetes CustomResourceDefinitions (CRDs)

_Custom resources_ are extensions of the Kubernetes API.

Let's define a new _resource_ called `Thingy`. A `Thingy` _object_ will have two properties: `name` and `value`.

```yaml

```

```text
$ kubectl apply -f thingy-crd.yaml
...
```

## References

<https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/>
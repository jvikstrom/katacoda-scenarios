The reason "kube-monkey" doesn't terminate anything is because it's entierly opt-in. In the deployment specs we need to add some tags to tell "kube-monkey" that it should kill pods here.

We do this by adding labels to the deployment spec. There are only three required labels to get "kube-monkey" to kill pods. `kube-monkey/enabled: enabled`, `kube-monkey/identifier` which should be set to some unique identifier and finally `kube-monkey/mtbf: '<some number>'` which is "mean time between failure" in days, i.e. how often you expect a pod to fail.

The labels should be added to our deployment so it looks like this:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <our-deployment-name>
  labels:
    kube-monkey/enabled: enabled
    kube-monkey/identifier: <our-unique-identifier>
    kube-monkey/mtbf: <how often a pod should be killed>
spec:
  template:
    metadata:
      labels:
        kube-monkey/enabled: enabled
        kube-monkey/identifier: <our-unique-identifier>
	kube-monket/mtbf: <how often a pod should be killed>

```

This is pre-prepared in `km-deployment.yml`, so to add these labels to the current deployment just run:
```
kubectl apply -f km-deployment.yml
```{{execute}}
And the deployment will re-deploy out pods with the new settings.

Now let's watch "kube-monkey" kill some pods. Run:
```
kubectl logs -f $(kubectl get pods | tr ' ' '\n' | grep kube-monkey)
```{{execute}}
To print the "kube-monkey" logs.

When you see a message that "kube-monkey" has terminated a "nice-pod" you can CTRL+C out of the log window. Do a `kubectl get pods` and you'll notice that two pods have just restarted.

This means kube-monkey is working!



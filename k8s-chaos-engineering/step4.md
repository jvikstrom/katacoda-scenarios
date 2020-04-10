The reason kube-monkey doesn't terminate anything is because it's entierly opt-in. In the deployment specs we need to define that kube-monkey should kill pods here.

We do this by adding labels to the deployment spec. There are only two required labels to get kube-monkey to kill pods. `kube-monkey/enabled: enabled` and `kube-monkey/identifier` which should be set to some unique identifier.

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

This is pre-prepared in `km-deployment.yml`, so to add these labels just run:
```
### kubectl delete deployment nice-pod
kubectl apply -f km-deployment.yml
```


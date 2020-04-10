So let's actually get started on deploying kube-monkey. What kube-monkey is going to do is that it will pick pods amongst deployments that define and it will then kill those pods.

### Deploying kube-monkey
First let's deploy the config. For now just run 
```
kubectl create configmap km-config --from-file=config.toml=kube-monkey-config.toml

```

This will create a ConfigMap object that kube-monkey can read when we deply it. We'll talk more about configs later on.

Next up is actually deploying the kube-monkey deployment. For this all we need to do is do the command.
```
kubectl apply -f kube-monkey.yml
```

Wait for a bit until the kube-monkey pod has status `RUNNING` (you get pod statuses at `kubectl get pods`).

At this point nothing should happen. If you check the logs for the kube-monkey pod you will see that no terminations were scheduled. Which is what we'll solve next.

So let's actually get started deploying kube-monkey. What it'll `kube-monkey` is going to do is that it will pick pods amongst deployments that have opted in and kill their pods.

### Deploying kube-monkey
First let's deploy the config. For now we won't talk about the config, so just run:
```
kubectl create configmap km-config --from-file=config.toml=kube-monkey-config.toml
```

This will create a ConfigMap object that `kube-monkey` can read when we deploy it. We'll talk more about configs later on.

Next up is actually deploying the `kube-monkey` app. For this all we need to do is run this command:
```
kubectl apply -f kube-monkey.yml
```
The deployment file just consist of a normal deployment spec with the `kube-monkey` image.

Wait for a bit until the `kube-monkey` pod has status `RUNNING` (you can see pod statuses with `kubectl get pods`).

At this point nothing should happen. If you check the logs for the `kube-monkey` pod you will see that no terminations were scheduled. This is what we'll solve next.
(To see the kube-monkey logs you can run this command:)
```
kubectl logs -f $(kubectl get pods | tr ' ' '\n' | grep kube-monkey)
```

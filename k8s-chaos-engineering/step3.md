So let's actually get started deploying "kube-monkey". What "kube-monkey" is going to do is that it will pick pods amongst the deployments that have opted in and kill their pods.

### Deploying kube-monkey
For now we'll not talk about how to configure "kube-monkey", so let's just deploy it using:
```
kubectl create configmap km-config --from-file=config.toml=kube-monkey-config.toml
```{{execute}}

This will create a ConfigMap object that `kube-monkey` can read when we deploy it. But we'll talk more about that config later.

Next up is actually deploying the `kube-monkey` application. For this all we have a deployment file, that we can deploy using this command:
```
kubectl apply -f kube-monkey.yml
```{{execute}}

The deployment file just consist of a normal deployment spec with the `kube-monkey` image. The one important difference to "normal" deployment specs is this part:
```
           volumeMounts:
             - name: config-volume
               mountPath: "/etc/kube-monkey"
      volumes:
        - name: config-volume
          configMap:
            name: km-config
```
This tells kubernetes to mount the "mk-config" ConfigMap as a volume in "/etc/kube-monkey" which the pods can read. This is how "kube-monkey" reads its config.

### Waiting for deployment...


Wait for a bit until the "kube-monkey" pod has status `RUNNING`. This may take a while as the image is downloaded. (you can see pod statuses with `kubectl get pods`).

At this point nothing should happen. If you check the logs for the "kube-monkey" pod you will see that no terminations were scheduled. This is what we'll solve next.
(To see the kube-monkey logs you can run this command):

```
kubectl logs -f $(kubectl get pods | tr ' ' '\n' | grep kube-monkey)
```{{execute}}

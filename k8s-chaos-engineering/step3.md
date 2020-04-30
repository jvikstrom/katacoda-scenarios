So let's actually get started deploying "kube-monkey". What "kube-monkey" is going to do is that it will pick pods amongst the deployments that have opted in and kill their pods.

### Deploying kube-monkey
"kube-monkey" requires a config file that, amongst others, define the interval of time during the day when it should kill pods. It's also used to set which namespaces it should kill pods in and whether or not to run in debug mode. A basic config file containing this exist in "kube-monkey-config.toml".

To view the file run `cat kube-monkey-config.toml`{{execute}}.

To deploy the config as a ConfigMap to Kubernetes run:
```
kubectl create configmap km-config --from-file=config.toml=kube-monkey-config.toml
```{{execute}}

Now we have created a ConfigMap that "kube-monkey" can read from when we deploy it, but we'll go deeper into the config later.

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
This tells kubernetes to mount the "km-config" ConfigMap as a volume in "/etc/kube-monkey" which the pods can read. This is how "kube-monkey" reads its config.

### Waiting for deployment...


Wait for a bit until the "kube-monkey" pod has status `RUNNING`. This may take a while as the image is downloaded. (you can see pod statuses with `kubectl get pods`{{execute}}).

At this point nothing should happen. If you check the logs for the "kube-monkey" pod, under "***Today's Schedule***", you will see that no terminations were scheduled. This is what we'll solve in the next step.
(To see the kube-monkey logs you can run this command, note that you might have to wait a few minutes to see the message):

```
kubectl logs -f $(kubectl get pods | tr ' ' '\n' | grep kube-monkey)
```{{execute}}

(Note that you need to "CTRL+C" afterwards as this command 'follows' the "kube-monkey" logs)

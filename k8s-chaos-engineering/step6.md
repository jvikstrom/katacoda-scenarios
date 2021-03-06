Finally let's look at how we change the actual "kube-monkey" config. The current config file is in "kube-monkey-config.toml" so let's make some changes there to make it ready for production. The main thing we will do is remove the debug config.

The the new config will look like:
```
[kubemonkey]
dry_run = false
run_hour = 8
start_hour = 10
end_hour = 16
blacklisted_namespaces = ["kube-system"]
whitelisted_namespaces = ["default"]
time_zone = "Europe/Stockholm"
```

Let's update the config, first let's replace the config definition in our .toml:
```
echo '[kubemonkey]
dry_run = false
run_hour = 8
start_hour = 10
end_hour = 16
blacklisted_namespaces = ["kube-system"]
whitelisted_namespaces = ["default"]
time_zone = "Europe/Stockholm"
' > kube-monkey-config.toml
```{{execute}}

Secondly, we need to create the ConfigMap Kubernetes yaml definition. Then we need to use this yaml to replace the current ConfigMap that we deployed in step  3. To do this, run: 

```
kubectl create configmap km-config --dry-run -o yaml --from-file=config.toml=kube-monkey-config.toml | kubectl replace -f-
```{{execute}}

This command first creates a Kubernetes ConfigMap "km-config" but does not deploy it, instead it writes the yaml to stdout. At which point we use that yaml in "kubectl replace" to replace the ConfigMap.

Finally to get "kube-monkey" to load the new config we need to restart the pod. To do this just delete the "kube-monkey" pod and Kubernetes will create a new one automatically. You can delete the pod using:
```
kubectl delete pod $(kubectl get pods | tr ' ' '\n' | grep kube-monkey)
```{{execute}}


After this "kube-monkey" is ready to run and kill pods in the Kubernetes cluster, and now you know everything there is to know about using "kube-monkey" for chaos engineering in Kubernetes.

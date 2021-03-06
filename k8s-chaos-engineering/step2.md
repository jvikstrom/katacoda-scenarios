What "kube-monkey" does under the hood is that it uses the Kubernetes API to kill pods. This means that we need to give the deployment permissions to kill pods, as pods by default don't have these permissions. So we somehow need to make sure "kube-monkey" has permissions to kill pods.

#### The "easy" way
The easiest way to give these permissions to a deployment is to deploy in the "kube-system" namespace, this is where the Kubernetes system services are deployed and everything here gets "admin" rights to the entire cluster.

#### The "correct" way
Following the principle of least privilege we do not want to give "kube-monkey" admin permissions to the entire cluster. What we will do instead is create a service account specifically for "kube-monkey" - giving it only the permissions it requires.

The permissions "kube-monkey" needs to run are: cluster wide list and get of deployments, statefulsets and daemonsets. It also needs get, delete and list permissions of pods in the namespaces it will kill pods in. In our case the namespace we are interested in is the "default" namespace.

All the required roles, role bindings and the service account definitions are pre-prepared in `service-account.yml`. To view them run `cat service-account.yml`{{execute}}.

It contains a ClusterRole for listing and reading deployments, statefulsets and daemonsets. It also contains a Role for the default namespace to delete and list pods. In addition it contains a service account to be used by kube-monkey and associated role bindings to the roles it creates.

To add it to the cluster run:
```
kubectl apply -f service-account.yml
```{{execute}}

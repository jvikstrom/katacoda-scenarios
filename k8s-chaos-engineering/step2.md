What kube-monkey does under the hood is that it uses the kubernetes api to kill pods. This means that we need to give the kube-monkey deployment permissions to kill pods, by default pods don't have these permissions. The easiest way to give these permissions to a deployment is to deploy in the `kube-system` namespace, this is where the kubernetes system services are deployed and everything here gets "admin" rights to the entire clutser. 

### The other way
This is not really something you want to do. As this gives `kube-monkey` admin permissions to the entire cluster. What we will do instead is create a service account only for `kube-monkey` - giving it only the permissions it requires.

The permissions `kube-monkey` needs to run are: cluser wide listing and getting permissions of deployments, statefulsets and daemonsets. It also needs get, delete and list permissions of pods in the namespaces it will kill pods in.

All of this is pre-prepared in `service-accounts.yml`, it contains the service account definition, roles and role bindings to the service account.

To add it to the cluster just run:
```
kubectl apply -f service-accounts.yml
```

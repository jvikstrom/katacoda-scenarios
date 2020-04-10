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

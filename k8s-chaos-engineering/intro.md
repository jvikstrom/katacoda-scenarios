This tutorial gives a step-by-step overview on how to deploy `kube-monkey` using kubernetes deployment specs. Kube-monkey is a tool for testing Kubernetes applications with chaos engineering, randomly turning off pods. This is done in the hopes that bugs induced by failures in a distributed setting are uncovered in a controlled way - which over time will lead to improved resiliency and decreasing downtime.

Kube-monkey leverages the kubernetes API to find pods and turn them off, this means we need to give the deployment special permissions. The easy way is deploying in "kube-system", but that means it can do much more then just turn off pods in the cluster. So it should be deployed with just the permissions it requires - which is what we will do in this tutorial.


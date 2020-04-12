Let's take a step back and look at how you configure kube-monkey.
There is a large set of configuration options for kube-monkey, they're outlined below.

```
# All the config options below are set to their default value.
[kubemonkey] # Start of the main group of config options.
dry_run = true # If true , kube-monkey will only log and not actually kill any pods.
time_zone = "America/Los_Angeles" # The timezone that will be used in scheduling kills and when printing logs.
run_hour = 8 # What hour of the day that kube-monkey should schedule the terminations for the day.
start_hour = 10 # Earliest time of day that kube-monkey will kill pods.
end_hour = 16 # Latest time of day that kube-monkey will kill pods.
graceperiod_sec = 5 # How long kube-monkey will wait for a pod to terminate before force-killing the pod.
whitelisted_namespaces = ["default"] # Namespaces kube-monkey will kill pods in.
blacklisted_namespaces = ["kube-system"] # Namespaces kube-monkey is never allowed to kill pods in.
host = (No default, uses in-cluster config by default) # URL to the kubernetes API host.

[debug]
enabled = false # If debug is enabled.
schedule_delay = 30 # Time in seconds that kube-monkey should delay before scheduling.
force_should_kill = false # Guarantees that all eligable deployments will have pods be killed (i.e. make it not care about the mtbf value).
schedule_immediate_kill = false # Schedules pod kills sometime in the next 60 seconds.

```

## The deployment configs
For configuring the deployments that we want to be killed by kube-monkey there are also a number of config options.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: the-victim
  labels:
    kube-monkey/enabled: enabled  # (Required) Tells kube-monkey this deployment is enrolled.
    kube-monkey/identifier: <identifier> # (Required) Identifier kube-monkey uses for bookkeeping (should be unique).
    kube-monkey/mtbf: '2' # (Required) Mean-time-between-failure (in days)
    kube-monkey/kill-mode: "fixed" # One of "kill-all", "fixed", "random-max-percent" and "fixed-percent"
    kube-monkey/kill-value: '1' # If kill-mode is "fixed": specify the number of pods to kill, if "random-max-percent": specify max-percent of pods to kill, if "fixed-percent": specify percent of pods to kill.
spec:
  template:
    metadata:
      labels:
        kube-monkey/enabled: enabled # (Required) Should be same value as above.
        kube-monkey/identifier: <identifier> # (Required) Should be same value as above.
```


So let's configure our "nice-pod" to have one pod killed every two days and change the grace period to two seconds.

Change the `km-deployment.yml` labels to include:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: the-victim
  labels:
    ...
    kube-monkey/mtbf: '2'
    kube-monkey/kill-mode: "fixed"
    kube-monkey/kill-value: '1'
    ...
```

And run `kubectl apply -f km-deployment.yml`, this has been preconfigured in single-kill-deployment.yml, so you can also just run `kubectl apply -f single-kill-deployment.yml`.
This will make kube-monkey rreload the deployment config the next time it schedules terminations.


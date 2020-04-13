Let's take a step back and look at how you configure "kube-monkey".
There is a large set of configuration options for "kube-monkey", they're outlined below.

Main config block
* dry\_run: If true, "kube-monkey" will only log and not actually kill any pods.
* time\_zone: The timezone that will be used in scheduling kills and when printing logs.
* run\_hour: What hour of the day that "kube-monkey" should schedule the terminations for the day.
* start\_hour: Earliest time of day that "kube-monkey" will kill pods.
* end\_hour: Latest time of day that "kube-monkey" will kill pods.
* graceperiod\_sec: How long "kube-monkey" will wait for a pod to terminate before force-killing the pod.
* whitelisted\_namespaces: Namespaces "kube-monkey" will kill pods in.
* blacklisted\_namespaces: Namespaces "kube-monkey" is never allowed to kill pods in.
* host: URL to the kubernetes API host.  (No default, uses in-cluster config by default)

Debug config block:
* enabled: If debug is enabled.
* schedule\_delay: Time in seconds that "kube-monkey" should delay before scheduling.
* force\_should\_kill: Guarantees that all eligable deployments will have pods be killed (i.e. make it not care about the mtbf value).
* schedule\_immediate\_kill: Schedules pod kills sometime in the next 60 seconds.

And this is an example of a config file.
```
# All the config options below are set to their default value.
[kubemonkey]
dry_run = true
time_zone = "America/Los_Angeles"
run_hour = 8
start_hour = 10
end_hour = 16
graceperiod_sec = 5
whitelisted_namespaces = ["default"]
blacklisted_namespaces = ["kube-system"]

[debug]
enabled = false
schedule_delay = 30
force_should_kill = false
schedule_immediate_kill = false
```

## The deployment configs
For configuring the deployments that we want to be killed by kube-monkey there are also a number of config options.

The set of different labels we can set are:
* kube-monkey/enabled: (Required) Tells kube-monkey this deployment is enrolled.
* kube-monkey/identifier: (Required) Identifier `kube-monkey` uses for bookkeeping (should be unique).
* kube-monkey/mtbf: (Required) Mean-time-betwee-Failure (in days).
* kube-monkey/kill-mode: One of "kill-all", "fixed", "random-max-percent" or "fixed-percent".
* kube-monkey/kill-value: If kill-mode is "fixed": specify the number of pods to kill, if "random-max-percent": specify max-percent of pods to kill, if "fixed-percent": specify percent of pods to 
kill.

An example of a deployment spec. is found below:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: the-victim
  labels:
    kube-monkey/enabled: enabled
    kube-monkey/identifier: <identifier>
    kube-monkey/mtbf: '2'
    kube-monkey/kill-mode: "fixed"
    kube-monkey/kill-value: '1'
spec:
  template:
    metadata:
      labels:
        kube-monkey/enabled: enabled # (Required) Should be same value as above.
        kube-monkey/identifier: <identifier> # (Required) Should be same value as above.
```

## Configuring
So let's configure our "nice-pod" to have one pod killed every two days and change the grace period to two seconds.

Change the `km-deployment.yml` labels using vim to include:
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

And run `kubectl apply -f km-deployment.yml`, this has also been preconfigured in `single-kill-deployment.yml`, so you could also just run `kubectl apply -f single-kill-deployment.yml`.

"Kube-monkey" will automatically reload the deployment config the next time is schedules terminations.


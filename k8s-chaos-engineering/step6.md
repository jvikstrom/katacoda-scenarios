Finally let's look at how we change the actual kube-monkey config. The current config file is in `kube-monkey-config.toml` so let's make some changes there to make it ready for production. Really the main thing we need to change is to remove the debug config.

So the new config will look like:
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

Let's update the config:

```
echo "[kubemonkey]                        \
dry_run = false                           \
run_hour = 8                              \
start_hour = 10                           \
end_hour = 16                             \
blacklisted_namespaces = ["kube-system"]  \
whitelisted_namespaces = ["default"]      \
time_zone = "Europe/Stockholm"            \
" > kube-monkey-config.toml && kubectl create configmap km-config --from-file=config.toml=kube-monkey-config.toml
```


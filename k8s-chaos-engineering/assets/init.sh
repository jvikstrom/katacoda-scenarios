#!/bin/sh
minikube start --wait=false
kubectl apply -f deployment.yml

#/bin/bash


oc project kube-system

oc delete ds nvidia-device-plugin-daemonset

oc label node \
    localhost.localdomain openshift.com/gpu-accelerator=true \
    --overwrite=true

oc create -f nvidia-device-plugin-3.11.yaml

oc get pods

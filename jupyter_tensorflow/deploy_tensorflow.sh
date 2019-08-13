#/bin/bash
oc login https://192.168.0.19:8443 -u justin

oc project nvidia

oc delete all -l app=tensorflow -n nvidia
oc delete all -l app=tensorflow-gpu -n nvidia

oc create serviceaccount -n nvidia tensorflowuser
oc adm policy add-scc-to-user privileged -n nvidia -z tensorflowuser

oc new-app -f tensorflow.yaml


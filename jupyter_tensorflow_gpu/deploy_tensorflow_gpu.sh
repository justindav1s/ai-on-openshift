#/bin/bash
oc login https://ocp.datr.eu:8443 -u justin

PROJECT=tensorflow


oc delete project ${PROJECT}
oc new-project ${PROJECT} 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project ${PROJECT} 2> /dev/null
done

oc delete all -l app=tensorflow
oc delete all -l app=tensorflow-gpu
oc delete serviceaccount tensorflowuser
oc create serviceaccount tensorflowuser
oc adm policy add-scc-to-user privileged -z tensorflowuser


oc new-app -f tensorflow_gpu.yaml

#/bin/bash

oc login https://ocp.datr.eu:8443 -u justin

oc delete project nvidia
oc new-project nvidia 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project nvidia 2> /dev/null
done


oc create -f cuda-vector-add.yaml



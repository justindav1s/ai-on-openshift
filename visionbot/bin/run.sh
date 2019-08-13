#!/bin/bash
export IP=ocp.datr.eu
export USER=justin
export PROJECT=visionbot
export IMAGE_NAMESPACE=$PROJECT
export IMAGE=tfchatbot

oc login ${IP}:8443 -u ${USER}

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc new-app python:3.6~https://github.com/justindav1s/ai-on-openshift.git --context-dir=visionbot
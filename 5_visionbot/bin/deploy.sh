#!/bin/bash
export IP=ocp.datr.eu
export USER=justin
export APP=visionbot
export PROJECT=${APP}


oc login ${IP}:8443 -u ${USER}

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc new-app -f deploy-template.yaml \
    -p APP_NAME=${APP} \
    -p GIT_URI=https://github.com/justindav1s/ai-on-openshift.git \
    -p GIT_CONTEXT_DIR=5_visionbot/src

oc start-build ${APP} --follow

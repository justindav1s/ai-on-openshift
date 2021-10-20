#!/usr/bin/env bash

. ./env.sh

oc login https://${OCP} -u $USER

oc project $PROJECT

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done


cd templates


oc new-app jupyterhub.yaml \
   -p NOTEBOOK_REPOSITORY_URL=https://github.com/justindav1s/ai-on-openshift \
   -p NOTEBOOK_REPOSITORY_CONTEXT_DIR=2_nvidia_jupyter_notebook_build/tensorflow-notebook \
   -p NOTEBOOK_PYTHON_VERSION=latest

oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}:jupyterhub-hub -n ${NOTEBBOKS_NS}
oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}:builder -n ${NOTEBBOKS_NS}

oc adm policy add-role-to-user cluster-admin -z jupyterhub-hub

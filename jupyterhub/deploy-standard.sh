#!/usr/bin/env bash

. ./env.sh


oc delete all -l app=jupyterhub
oc delete configmaps "jupyterhub-cfg"
oc delete serviceaccounts "jupyterhub-hub"
oc delete rolebindings.authorization.openshift.io "jupyterhub-edit"
oc delete persistentvolumeclaims "jupyterhub-db"
oc delete templates.template.openshift.io "jupyterhub-deployer"

oc create -f jupyterhub-deployer.yaml

oc new-app --template jupyterhub-deployer \
   -p APPLICATION_NAME=jupyterhub \
   -p JUPYTERHUB_IMAGE=jupyterhub:${JUPYTERHUB_VERSION} \
   -p NOTEBOOK_IMAGE=${NOTEBOOK_IMAGE} \
   -p JUPYTERHUB_MEMORY=512Mi \
   -p DATABASE_MEMORY=512Mi \
   -p NOTEBOOK_MEMORY=2Gi

oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}:jupyterhub-hub -n ${NOTEBBOKS_NS}

oc adm policy add-role-to-user cluster-admin -z jupyterhub-hub

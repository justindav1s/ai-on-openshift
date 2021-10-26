#!/usr/bin/env bash

. ./env.sh

APPLICATION_NAME=jupyterhub

oc project ${PROJECT}
cd templates

oc delete is ${APPLICATION_NAME}-nb-img
oc delete bc ${APPLICATION_NAME}-nb-img

oc new-app notebook-bc.yaml \
   -p APPLICATION_NAME=${APPLICATION_NAME} \
   -p NOTEBOOK_REPOSITORY_URL=https://github.com/justindav1s/ai-on-openshift \
   -p NOTEBOOK_REPOSITORY_CONTEXT_DIR=2_nvidia_jupyter_notebook_build/tensorflow-notebook \
   -p BASE_IMAGE=quay.io/justindav1s/gpu-notebook-base:latest

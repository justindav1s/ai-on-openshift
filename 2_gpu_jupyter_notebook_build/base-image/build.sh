#!/usr/bin/env bash

. ../env.sh

APP=ubi8-python-38
GIT_URL=https://github.com/justindav1s/ai-on-openshift.git

oc project ${PROJECT}

oc delete bc ${APP}-docker-build

oc process -f docker-build-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p SOURCE_REPOSITORY_URL=${GIT_URL} \
    -p SOURCE_REPOSITORY_REF=master \
    -p DOCKERFILE_PATH=2_gpu_jupyter_notebook_build/ubi8-base-image \
    -p DOCKERFILE_NAME=Dockerfile-ubi8-py38.nvidia \
    | oc apply -n ${PROJECT} -f -
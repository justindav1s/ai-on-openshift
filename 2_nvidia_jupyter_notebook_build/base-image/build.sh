#!/usr/bin/env bash

. ../env.sh

APP=python-36-centos7-nvidia
GIT_URL=https://github.com/justindav1s/ai-on-openshift.git

oc project ${PROJECT}

oc delete bc ${APP}-docker-build

oc process -f docker-build-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p SOURCE_REPOSITORY_URL=${GIT_URL} \
    -p SOURCE_REPOSITORY_REF=master \
    -p DOCKERFILE_PATH=nvidia-notebook/base-image \
    -p DOCKERFILE_NAME=Dockerfile-py36.nvidia \
    | oc apply -n ${PROJECT} -f -

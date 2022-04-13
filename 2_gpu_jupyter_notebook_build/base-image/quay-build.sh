#!/usr/bin/env bash

. ../env.sh

APP=gpu-base
GIT_URL=https://github.com/justindav1s/ai-on-openshift.git

oc project ${PROJECT}

oc delete bc ${APP}-docker-build

oc create secret docker-registry quayio-dockercfg \
  --docker-server=${QUAYIO_HOST} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n ${PROJECT}

oc process -f docker-build-quay-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p SOURCE_REPOSITORY_URL=${GIT_URL} \
    -p SOURCE_REPOSITORY_REF=master \
    -p DOCKERFILE_PATH=2_gpu_jupyter_notebook_build/base-image \
    -p DOCKERFILE_NAME=Dockerfile-ubi8-py38.nvidia \
    | oc apply -n ${PROJECT} -f -

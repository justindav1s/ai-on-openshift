#!/usr/bin/env bash

. ../env.sh

APPLICATION_NAME="s2i-nvidia-notebook"
SOURCE_REPOSITORY_URL="https://github.com/justindav1s/ai-on-openshift.git"
SOURCE_REPOSITORY_REF="master"
REPO_PATH="2_gpu_jupyter_notebook_build/s2i-notebook-image/minimal-notebook"
BASE_IMAGE="quay.io/justindav1s/gpu-base:latest"
BASE_IMAGE_NS="jupyter-notebooks"

oc project ${PROJECT}

oc delete is ${APPLICATION_NAME}
oc delete bc ${APPLICATION_NAME}-bc

oc create secret docker-registry quayio-dockercfg \
  --docker-server=${QUAYIO_HOST} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n ${PROJECT}

oc process -f s2i-nvidia-notebook-bc.yaml \
  -p APPLICATION_NAME=${APPLICATION_NAME} \
  -p SOURCE_REPOSITORY_URL=${SOURCE_REPOSITORY_URL} \
  -p SOURCE_REPOSITORY_REF=${SOURCE_REPOSITORY_REF} \
  -p REPO_PATH=${REPO_PATH} \
  -p BASE_IMAGE=${BASE_IMAGE} \
  -p BASE_IMAGE_NS=${BASE_IMAGE_NS} \
  | oc apply -f -

oc start-build ${APPLICATION_NAME}-bc -n ${PROJECT}
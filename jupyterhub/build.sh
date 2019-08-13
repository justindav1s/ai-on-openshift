#!/usr/bin/env bash

. ./env.sh

oc delete bc jupyterhub-bc
oc delete is jupyterhub

oc process -f jupyterhub-bc.yaml \
    -p VERSION=${JUPYTERHUB_VERSION} \
    | oc apply -n ${PROJECT} -f -

#!/bin/bash
export IP=127.0.0.1
export USER=justin
export PROJECT=tensorflow2
export IMAGE_NAMESPACE=$PROJECT
export IMAGE=tfchatbot

oc login ${IP}:8443 -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin $USER

oc login ${IP}:8443 -u $USER

oc new-project ${PROJECT}

oc project $PROJECT

oc new-app centos/python-35-centos7~https://github.com/justindav1s/openshift_chatbot.git
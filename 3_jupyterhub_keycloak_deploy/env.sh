#!/usr/bin/env bash

export OCP=ocp.datr.eu
export USER=justin
export PROJECT=jupyterhub-keycloak
export NOTEBBOKS_NS=jupyter-notebooks
export JUPYTERHUB_VERSION=3.1.0
export NOTEBOOK_IMAGE="docker-registry.default.svc:5000/${NOTEBBOKS_NS}/tensorflow-nvidia-notebook:latest"

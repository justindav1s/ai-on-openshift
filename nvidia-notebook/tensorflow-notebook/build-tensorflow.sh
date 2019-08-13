#!/usr/bin/env bash

oc new-build --name tensorflow-nvidia-notebook \
  --image-stream s2i-nvidia-minimal-notebook:latest \
  --code https://github.com/justindav1s/ai-on-openshift.git \
  --context-dir nvidia-notebook/tensorflow-notebook

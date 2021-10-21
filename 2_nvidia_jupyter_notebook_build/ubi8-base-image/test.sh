#!/bin/bash


IMAGE=quay.io/justindav1s/gpu-base:latest


oc run gpu-shell --rm -i --tty --image ${IMAGE} -- bash

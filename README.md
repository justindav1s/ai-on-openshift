# Using Openshift to train and serve AI/ML models

## Configuring Openshift to use GPUs


## Building Jupyter notebooks capable of running AI/ML workloads using Tensorflow and GPUs


## Dploying Jupyter Notebooks at scale


## Developing AI/ML models with Openshift and Jupyter Notebooks


## Deploying and using AI/ML models on OPenshift



# Sources

https://github.com/kubeflow/kubeflow

https://www.lightbend.com/blog/how-to-deploy-kubeflow-on-lightbend-platform-openshift-introduction

https://github.com/rbo/RedHatHackathon-KubeFlow-Demo/blob/master/deployer/kubeflow-deploy.sh


# GPU stuff

1. Install CUDA, this will also install an appropriate driver

https://blog.openshift.com/how-to-use-gpus-with-deviceplugin-in-openshift-3-10/

for OCP 3.11 start here :

DSX

http://docs.h2o.ai/driverless-ai/latest-stable/docs/userguide/install/rhel.html


https://nvidia.github.io/nvidia-docker/

## Argo

https://github.com/argoproj/argo/blob/master/demo.md

https://github.com/argoproj/argo/issues/922

MiniKF
                             ┌──────Minikube + Kubeflow + Rok = MiniKF────────┐
                             │ Provisioning completed.                        │
                             │                                                │
                             │                                                │
                             │ Services:                                      │
                             │   * Kubeflow:   http://10.10.10.10:8080/       │
                             │   * Rok:        http://10.10.10.10:8080/rok/   │
                             │                                                │
                             │ Credentials:                                   │
                             │   * Username:   user                           │
                             │   * Password:   12341234                       │
                             ├────────────────────────────────────────────────┤
                             │                   <  OK  >                     │
                             └────────────────────────────────────────────────┘

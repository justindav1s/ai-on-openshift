# Sources

https://github.com/kubeflow/kubeflow

https://www.lightbend.com/blog/how-to-deploy-kubeflow-on-lightbend-platform-openshift-introduction

https://github.com/rbo/RedHatHackathon-KubeFlow-Demo/blob/master/deployer/kubeflow-deploy.sh


# GPU stuff

1. Install CUDA, this will also install an appropriate driver

https://blog.openshift.com/how-to-use-gpus-with-deviceplugin-in-openshift-3-10/

for OCP 3.11 start here :

https://developer.ibm.com/linuxonpower/2018/09/19/using-nvidia-docker-2-0-rhel-7/

https://docs.openshift.com/container-platform/3.11/dev_guide/device_plugins.html

https://github.com/NVIDIA/k8s-device-plugin

https://github.com/NVIDIA/nvidia-docker

go to docker section, not docker-ce section

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)#prerequisites

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

# Jupyterhub Deployment

## Reference Documentation
https://github.com/jupyter-on-openshift/jupyter-notebooks

### Building an NVidia aware Jupyterhub compatible Jupyter notebook

Three stage processing

   1. Do a Docker build to add NVidia Libaries to a Python 36 image
   2. Convert the resulting image into one instrumented to do s2i for Jupyter notebooks
   3. Use the resulting image in an s2i build pointing at a repo with the necessary requirements.txt for Tensorflow etc.

See folder [nvidia-notebook](../nvidia-notebook)

Run the build scripts here :
   1. [base image build](../nvidia-notebook/base-image)    
   2. [s2i image build](../nvidia-notebook/s2i-image)
   3. [tensorflow image build](../nvidia-notebook/tensorflow-notebook)

## Reference Documentation
https://github.com/jupyter-on-openshift/jupyterhub-quickstart/tree/3.1.0

### Jupyterhub Setup

image-puller required because notebook images were built in another namespace

cluster-admin required because notebook pod using a GPU requires the privileged SCC. It seems you need to be cluster-admin to create such pods

For Jupyterhub to create pods that leverage the GPU it needs the below config in its ConfigMap : jupyterhub-cfg

```
c.KubeSpawner.privileged = True

c.Spawner.environment.update(dict(
       NVIDIA_VISIBLE_DEVICES='all',
       NVIDIA_DRIVER_CAPABILITIES='compute,utility',
       NVIDIA_REQUIRE_CUDA='cuda>=8.0'))

c.KubeSpawner.extra_resource_limits = {'nvidia.com/gpu': '1'}
```

Run the build scripts here :
   1. [namespace setup](setup.sh)    
   2. [build a Jupyterhub image](build.sh)
   3. [deploy Jupyterhub](deploy-standard.sh)

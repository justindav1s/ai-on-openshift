# Jupyterhub with Keycloak user management

## Reference Documentation
https://github.com/jupyter-on-openshift/poc-hub-keycloak-auth


docker-registry.default.svc:5000/jupyter-notebooks/tensorflow-nvidia-notebook:latest

JupyterHub (KeyCloak)
=====================

This repository contains a sample application for deploying JupyterHub as a means to provide Jupyter notebooks to multiple users. Authentication of users is managed using KeyCloak.

Deploying the application
-------------------------

To deploy the sample application, you can run:

```
oc new-app https://raw.githubusercontent.com/jupyter-on-openshift/poc-hub-keycloak-auth/master/templates/jupyterhub.json
```

This will create all the required builds and deployments from the one template.

If desired, you can instead load the template, with instantiation of the template done as a separate step from the command line or using the OpenShift web console.

Resource requirements
---------------------

If deploying to an OpenShift environment that enforces quotas, you must have a memory quota for terminating workloads (pods) of 3GiB so that builds can be run. For one user, you will need 6GiB of quota for terminating workloads (pods). Each additional user requires 1GiB.

For storage, two 1GiB persistent volumes are required for the PostgreSQL databases for KeyCloak and JupyterHub. Further, each user will need a 1GiB volume for notebook storage.

Registering a user
------------------

KeyCloak will be deployed, with JupyterHub and KeyCloak automatically configured to handle authentication of users. No users are setup in advance, but users can register themselves by clicking on the _Register_ link on the login page.



```
apiVersion: v1
data:
  admin_users.txt: ''
  jupyterhub_config.py: |-
    c.KubeSpawner.privileged = True

    c.Spawner.environment.update(dict(
           NVIDIA_VISIBLE_DEVICES='all',
           NVIDIA_DRIVER_CAPABILITIES='compute,utility',
           NVIDIA_REQUIRE_CUDA='cuda>=8.0'))

    c.KubeSpawner.extra_resource_limits = {'nvidia.com/gpu': '1'}
  user_whitelist.txt: ''
kind: ConfigMap
metadata:
  annotations:
    openshift.io/generated-by: OpenShiftNewApp
  creationTimestamp: '2019-07-28T12:03:52Z'
  labels:
    app: jupyterhub
  name: jupyterhub-cfg
  namespace: jupyterhub-keycloak2
  resourceVersion: '1538167'
  selfLink: /api/v1/namespaces/jupyterhub-keycloak2/configmaps/jupyterhub-cfg
  uid: c4050f2a-b12f-11e9-a238-309c235ef316
```

#/bin/bash

# https://developer.ibm.com/linuxonpower/2018/09/19/using-nvidia-docker-2-0-rhel-7/

#run on the master as root

# 1. If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
yum remove nvidia-docker

# 2. Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo | tee /etc/yum.repos.d/nvidia-container-runtime.repo

# 3. Install the nvidia runtime hook
#yum install -y nvidia-container-runtime-hook

# 20 July, NVidia deprecated nvidia-container-runtime-hook in favour of something that only works for Docker 19.03 and up.
# this breaks docker on RHEL7 for OCP which is Docker 1.13.1
# need to be quite careful to get the previous runtime hook setup, see below
repoquery --show-duplicates nvidia-container-runtime-hook*
yumdownloader nvidia-container-runtime-hook-0:1.4.0-2.x86_64
yum localinstall nvidia-container-runtime-hook-1.4.0-2.x86_64.rpm


# NOTE:  Step 4 is only needed if you're using the older nvidia-container-runtime-hook-1.3.0  The default(1.4.0) now includes this file
# 4. Add hook to OCI path

mkdir -p /usr/libexec/oci/hooks.d

echo -e '#!/bin/sh\nPATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" exec nvidia-container-runtime-hook "$@"' | tee /usr/libexec/oci/hooks.d/nvidia

chmod +x /usr/libexec/oci/hooks.d/nvidia

# 5. Adjust SELINUX Permissions
chcon -t container_file_t  /dev/nvidia*


#[root@localhost ~]# ls -ltr /usr/libexec/oci/hooks.d
#total 3344
#-rwxr-xr-x. 1 root root 3358176 Feb  1  2018 oci-register-machine
#-rwxr-xr-x. 1 root root     127 Sep  6  2018 oci-nvidia-hook
#-rwxr-xr-x. 1 root root   28408 Nov  6  2018 oci-umount
#-rwxr-xr-x. 1 root root   32536 May 14 16:24 oci-systemd-hook
#[root@localhost ~]# echo -e '#!/bin/sh\nPATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" exec nvidia-container-runtime-hook "$@"' | tee /usr/libexec/oci/hooks.d/nvidia
##!/bin/sh
#PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" exec nvidia-container-runtime-hook "$@"
#[root@localhost ~]# ls -ltr /usr/libexec/oci/hooks.d
#total 3348
#-rwxr-xr-x. 1 root root 3358176 Feb  1  2018 oci-register-machine
#-rwxr-xr-x. 1 root root     127 Sep  6  2018 oci-nvidia-hook
#-rwxr-xr-x. 1 root root   28408 Nov  6  2018 oci-umount
#-rwxr-xr-x. 1 root root   32536 May 14 16:24 oci-systemd-hook
#-rw-r--r--. 1 root root     118 Jul 24 08:53 nvidia
#[root@localhost ~]# chmod +x /usr/libexec/oci/hooks.d/nvidia
#[root@localhost ~]# chcon -t container_file_t  /dev/nvidia*
#[root@localhost ~]# ls -ltr /usr/libexec/oci/hooks.d
#total 3348
#-rwxr-xr-x. 1 root root 3358176 Feb  1  2018 oci-register-machine
#-rwxr-xr-x. 1 root root     127 Sep  6  2018 oci-nvidia-hook
#-rwxr-xr-x. 1 root root   28408 Nov  6  2018 oci-umount
#-rwxr-xr-x. 1 root root   32536 May 14 16:24 oci-systemd-hook
#-rwxr-xr-x. 1 root root     118 Jul 24 08:53 nvidia


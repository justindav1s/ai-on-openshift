#!/usr/bin/env bash

subscription-manager register --username=<username> --password=<password>
subscription-manager attach --pool=<poolid>
subscription-manager repos --disable=rhel-7-server-htb-rpms

subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.7-rpms" \
    --enable="rhel-7-server-optional-rpms"

yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct openshift-ansible docker-1.13.1 ansible

yum update -y

systemctl enable docker
systemctl start docker
systemctl is-active docker

# required to install cuda : July 2019
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum update -y
yum -y groupinstall "Development Tools"
yum install -y pciutils dkms kernel-devel

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=RHEL&target_version=7&target_type=rpmlocal
wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-rhel7-10-1-local-10.1.168-418.67-1.0-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel7-10-1-local-10.1.168-418.67-1.0-1.x86_64.rpm
sudo yum clean all
sudo yum install cuda

# remove the nouveau driver that will claim the GPU ahead of the NVidia driver
cat <<EOF > /usr/lib/modprobe.d/nvidia-installer-disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

cat <<EOF > /etc/modprobe.d/nvidia-installer-disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img

dracut /boot/initramfs-$(uname -r).img $(uname -r)

reboot

nvidia-smi

# Sat Jul 20 10:55:39 2019
# +-----------------------------------------------------------------------------+
# | NVIDIA-SMI 418.67       Driver Version: 418.67       CUDA Version: 10.1     |
# |-------------------------------+----------------------+----------------------+
# | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
# |===============================+======================+======================|
# |   0  GeForce GTX 105...  Off  | 00000000:01:00.0 Off |                  N/A |
# |  0%   39C    P0    N/A /  90W |      0MiB /  4040MiB |      1%      Default |
# +-------------------------------+----------------------+----------------------+

# +-----------------------------------------------------------------------------+
# | Processes:                                                       GPU Memory |
# |  GPU       PID   Type   Process name                             Usage      |
# |=============================================================================|
# |  No running processes found                                                 |
# +-----------------------------------------------------------------------------+

#now install ocp

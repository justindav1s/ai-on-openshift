#!/usr/bin/env bash

#This is the cloud-initscript that configures a openstack guest on Openstack to behave as a GPU node on Openshift

subscription-manager register --username=?? --password=??
subscription-manager attach --pool=??
subscription-manager repos --disable=rhel-7-server-htb-rpms
yum update -y

subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.7-rpms" \
    --enable="rhel-7-server-optional-rpms" \
    --enable="rh-gluster-3-client-for-rhel-7-server-rpms"
yum update -y
yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct ansible openshift-ansible docker-1.13.1

systemctl enable docker
systemctl start docker
systemctl is-active docker

rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum update -y
yum -y groupinstall "Development Tools"
yum install -y pciutils dkms kernel-devel

cd /tmp

wget https://s3-eu-west-1.amazonaws.com/??/NVIDIA-Linux-x86_64-390.87.run
chmod 755 NVIDIA-Linux-x86_64-390.87.run

cd /etc/pki/tls/private/
wget https://s3-eu-west-1.amazonaws.com/??/datr.eu.key
cd /etc/pki/tls/certs/
wget https://s3-eu-west-1.amazonaws.com/??/datr.eu.cer
wget https://s3-eu-west-1.amazonaws.com/??/ca.cer

cd ~/.ssh
rm -rf
cat <<EOF > id_rsa.pub
??
EOF
chmod 644 id_rsa.pub

cp id_rsa.pub authorized_keys
chmod 600 authorized_keys

cat <<EOF > id_rsa
??
EOF

chmod 600 id_rsa

cd ~
git clone https://github.com/justindav1s/openshift-ansible-on-openstack.git


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

mkdir /kube_volumes
chmod -R 777 /kube_volumes

reboot

#Install NVIDIA driver by hand.
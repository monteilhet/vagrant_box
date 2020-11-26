#!/bin/bash

# by default use --nox11
X11='--nox11'
[[ $1 != "" ]] && X11=

# yum -y update kernel
yum install -y epel-release
export KERN_DIR="/usr/src/kernels/$(ls /usr/src/kernels/)"
yum -y install kernel-devel kernel-headers dkms bzip2 gcc gcc-c++
mount /dev/sr0 /media ; cd /media
sh ./VBoxLinuxAdditions.run $X11
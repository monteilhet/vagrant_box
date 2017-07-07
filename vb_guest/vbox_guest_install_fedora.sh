#!/bin/bash

# yum -y update kernel
export KERN_DIR="/usr/src/kernels/$(ls /usr/src/kernels/)"
yum -y install kernel-devel kernel-headers dkms bzip2 gcc gcc-c++
mount /dev/sr0 /media ; cd /media
sh ./VBoxLinuxAdditions.run
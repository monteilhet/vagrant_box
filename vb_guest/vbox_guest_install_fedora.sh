#!/bin/bash

yum -y update kernel
yum -y install kernel-devel kernel-headers dkms bzip2 gcc gcc-c++
mount /dev/sr0 /media ; cd /media
sh ./VBoxLinuxAdditions.run
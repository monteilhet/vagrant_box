#!/bin/bash

# by default use --nox11
X11='--nox11'
[[ $1 != "" ]] && X11=

apt-get purge virtualbox-guest-dkms virtualbox-guest-source virtualbox-guest-utils virtualbox-guest-X11
apt-get install -y dkms build-essential module-assistant
apt-get install -y linux-headers-$(uname -r)
m-a prepare
mkdir -p /media/cdrom
mount /dev/sr0 /media/cdrom
cd /media/cdrom
sh VBoxLinuxAdditions.run $X11

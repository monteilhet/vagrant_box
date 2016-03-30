#!/bin/bash

apt-get purge virtualbox-guest-dkms virtualbox-guest-source virtualbox-guest-utils virtualbox-guest-X11
apt-get install dkms build-essential module-assistant
apt-get install linux-headers-$(uname -r)
m-a prepare
mount /dev/sr0 /media/cdrom
cd /media/cdrom
sh VBoxLinuxAdditions.run
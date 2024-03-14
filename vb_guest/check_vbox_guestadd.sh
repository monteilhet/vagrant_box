#!/bin/bash

ls /opt/VBoxGuest*

# test if vbox guest additions are installed
lsmod | grep -E "vbox(sf|guest)"

systemctl status vboxadd-service

ls /lib/modules/$(uname -r)/misc  # vboxguest.ko  vboxsf.ko  vboxvideo.ko

# test if vagrant is mount
mount | grep -c '/vagrant '
df -h | grep '/vagrant'

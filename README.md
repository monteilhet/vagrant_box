# materials to make a vagrant box

## VM settings

__Create a virtual machine using__

* VMDK dynamically resizing drive (80Go)
* RAM 256/512 Mo
* Disable audio, usb, etc. controllers unless they’re needed.
* Vagrant absolutely requires that the first network device must be a NAT device (use virtio-net).
   Vagrant uses this initial NAT device for setting up port forwards necessary for SSH.


__Install Operating System with__

    Hostname: vagrant-[os-name], e.g. vagrant-debian-wheezy or [os-name]-vagrantbox
    Domain: vagrantup.com / vagrant.net
    Root Password: vagrant
    Main account login: vagrant
    Main account password: vagrant

## Install

* VirtualBox Guest Additions (vb_guest script)
* system package

```
    ./<distro>_install.sh
    history -c && exit 0
```



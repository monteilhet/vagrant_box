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
    LVM partitioning :     Install using LVM with a single partition,
    and at end deselect all packages

## Install

* VirtualBox Guest Additions (vb_guest script)

```
   vb_guest/vbox_guest_install.sh  # x11 (to skip -nox11 option)
```


* system package

```
  ./<distro>_install.sh
  cd && > .bash_history && history -c && shutdown now
```

* localisation

timedatectl (utc 0)
localectl (keymap & locale)
locale en_US.UTF-8

## Optimisation

Use bento clean and minmize script
```
cd /tmp
git clone https://github.com/chef/bento
cd bento/packer_templates
su
# for debian
bash -v debian/scripts/update.sh
bash -v debian/scripts/cleanup.sh
bash -v _common/minimize.sh

# for centos
bash -v centos/scipts/update.sh
bash -v centos/scripts/cleanup.sh
bash -v _common/minimize.sh
```

## vagrant box

```bash
vagrant package --base  debian_image --output 2021-03-debian-10.8.box

```

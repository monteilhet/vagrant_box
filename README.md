# materials to make a vagrant box

## VM settings

__Create a virtual machine using__

* VMDK dynamically resizing drive (80Go)
* RAM 256/512 Mo
* Disable audio, usb, etc. controllers unless they’re needed.
* Vagrant absolutely requires that the first network device must be a NAT device (use virtio-net).

> Vagrant uses this initial NAT device for setting up port forwards necessary for SSH.


__Create a LVM partitioning with gpt parttion table__

 * use gparted iso to boot VM before installation
 * create a gpt partition table
 * create a LVM partition (and a boot partition 1G)
 * create VG debian / LV root
 * use a swapfile rather than a swap partition (NB ubuntu server create a swapfile by default)

__Install Operating System with__

    Hostname: [os-name]-box   (alt vagrant-[os-name], [os-name]-vagrantbox)
    Domain: local  (alt vagrantup.com / vagrant.net)
    Root Password: vagrant
    Main account login: vagrant
    Main account password: vagrant
    LVM partitioning :  Install using LVM with a single partition,
    and at end deselect all packages
    Centos/rockylinux: check network interface is active !

## Install

```
ssh vagrant@localhost -p 2299
cd /tmp
# debian/ubuntu
apt install -y sudo git
# centos/fedora
# yum install -y git
git clone https://github.com/monteilhet/vagrant_box.git
cd vagrant_box
```


* VirtualBox Guest Additions (vb_guest script)

```
   # => insert vbox_guest_add iso before
   vb_guest/vbox_guest_install.sh  # x11 (to skip -nox11 option)
```


* system package

```
  ./<distro>_install.sh
  cd && > .bash_history && history -c && shutdown now
```

* localisation

```
timedatectl
# to set UTC timezone : sudo timedatectl set-timezone UTC
localectl (keymap & locale)
locale en_US.UTF-8
```

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

# for centos/rockylinux
bash -v centos/scripts/update.sh
bash -v centos/scripts/cleanup.sh
bash -v _common/minimize.sh
```

## upgrade OS

### centos/rocky linux

```bash
sudo -i
dnf upgrade
```

### debian

```bash
sudo -i
apt update
apt upgrade

```

### kernel upgrade

If OS upgrade includes a new kernel => version clean older kernel

```
# centos/rockylinux
uname -a
rpm -qa *kernel*
yum remove kernel-modules-old_kernel_ver_x86_64 kernel-core-old_kernel_ver_x86_64 kernel-old_kernel_ver_x86_64 

# debian
dpkg -l *image*
apt purge <old kernel>

```

### update guest adds after kernel upgrade

```bash

# using vbox guest adds script currently installed : /opt/VBoxGuestAdditions-6.1.x
    apt-get install -y linux-headers-$(uname -r)
./init/vboxadd setup
```

#### centos/rocky linux clean grub entries

```bash
grubby --info ALL

# remove unwanted entry
grubby --remove-kernel=/boot/vmlinuz-0-rescue-c546e1415ae941d7a2d39ab3fd6860b7

# regenerate grub config
grub2-mkconfig -o /boot/grub2/grub.cfg
```

## upgrade virtual box guest additions

```bash
# => insert vbox_guest_add iso before
   git clone https://github.com/vagrant_box
   vagrant_box/vb_guest/vbox_guest_install.sh
# check virtual box guest additions
   vagrant_box/vb_guest/check_vbox_guestadd.sh 
```

## package vagrant box

```bash
vagrant package --base  debian_img --output 2021-03-debian-10.8.box
vagrant package --base  centos_img --output 2021-03-centos-8.3.box
vagrant package --base  rockylinux_img --output 2021-10-rockylinux-8.4.box

```

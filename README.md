# materials to make a vagrant box

## VM settings

__Create a virtual machine using__

* VMDK dynamically resizing drive (80Go)
* RAM 256/512 Mo
* Disable audio, usb, etc. controllers unless they’re needed.
* Vagrant absolutely requires that the first network device must be a NAT device (use virtio-net).
   Vagrant uses this initial NAT device for setting up port forwards necessary for SSH.


__Create a LVM partitioning with gpt parttion table__

 * use gparted iso to boot VM before installation
 * create a gpt partition table
 * create a LVM partition (and optionally a boot partition)
 * create VG debian / LV root 
 * use a swapfile rather than a swap partition

__Install Operating System with__

    Hostname: vagrant-[os-name], e.g.debian-box or [os-name]-vagrantbox
    Domain: vagrantup.com / vagrant.net
    Root Password: vagrant
    Main account login: vagrant
    Main account password: vagrant
    LVM partitioning :     Install using LVM with a single partition,
    and at end deselect all packages
    Centos: check network interface is active !

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

timedatectl (utc 0: sudo timedatectl set-timezone UTC)
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
bash -v centos/scripts/update.sh
bash -v centos/scripts/cleanup.sh
bash -v _common/minimize.sh
```

## vagrant box

```bash
vagrant package --base  debian_image --output 2021-03-debian-10.8.box
vagrant package --base  centos_image --output 2021-03-centos-8.3.box

```

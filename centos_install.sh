#!/bin/bash

# run as root
if [ “$(id -u)” != “0” ]; then
  echo !must be root!
  exit 1
fi

# ./centos_install.sh nofw nm # disable firewall, keep network manager
nf=${1:-nofw}
nm=${2:-nonm}

yum update -y
yum install -y sudo
yum install -y openssh-server
# yum install -y puppet

if [[ "$nf" == "nofw" ]] ; then
printf "\nDisable Firewall"
systemctl stop firewalld
systemctl disable firewalld
sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config
fi

if [[ "$nm" == "nonm" ]] ; then
printf "\nDisable NetworkManager"
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
rm -f /etc/resolv.conf # remove symbolic link
yum install network-scripts
systemctl enable network
systemctl start network
fi

echo > /etc/motd
cat motd/content >> /etc/motd
echo >> /etc/motd
echo "  "Box: `hostname -s` / Login: vagrant >> /etc/motd
echo "  "`cat /etc/centos-release` >> /etc/motd
echo "  "Released: $(date +%Y-%m-%d) >> /etc/motd
echo >> /etc/motd

echo "vagrant  ALL=(ALL) NOPASSWD: ALL" >  /etc/sudoers.d/vagrant

mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp ssh/authorized_keys ~/.ssh
chmod 600 ~/.ssh/authorized_keys

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cp ssh/authorized_keys /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh

sed -i 's/#UseDNS no/UseDNS no/' /etc/ssh/sshd_config

printf '\neval "$(dircolors /etc/DIR_COLORS)"' >> /root/.bashrc
printf '\neval "$(dircolors /etc/DIR_COLORS)"' >> /home/vagrant/.bashrc

if [[ $(swapon --show | wc -l) == 0 ]] ; then
dd if=/dev/zero of=/swapfile bs=1MiB count=$((2014))
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
bash -c 'echo "/swapfile none swap defaults 0 0" >> /etc/fstab'
fi
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo
echo "finish with :"
echo "> .bash_history && history -c && shutdown now"

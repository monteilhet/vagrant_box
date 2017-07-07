#!/bin/bash

# run as root
if [ “$(id -u)” != “0” ]; then
  echo !must be root!
  exit 1
fi

nm=${1:-nonm}

yum update -y
yum install -y sudo
yum install -y openssh-server
# yum install -y puppet

if [[ "$nm" == "nonm" ]] ; then
printf "\nDisable NetworkManager"
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config
rm -f /etc/resolv.conf # remove symbolic link
systemctl enable network
systemctl start network
fi

echo > /etc/motd
cat motd/content >> /etc/motd
echo >> /etc/motd
echo "  "Host: `hostname` / Login: vagrant >> /etc/motd
echo "  "`cat /etc/fedora-release` >> /etc/motd
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

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo
echo "finish with :"
echo "> .bash_history && history -c && shutdown now"

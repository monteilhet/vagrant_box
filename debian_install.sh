#!/bin/bash

# run as root
if [ “$(id -u)” != “0” ]; then 
  echo !must be root!
  exit 1
fi

apt-get update
apt-get install -y sudo
apt-get install -y openssh-server
# apt-get install -y puppet

echo >> /etc/motd
cat motd/content >> /etc/motd
echo >> /etc/motd
echo "  "Host: `hostname` / Login: vagrant >> /etc/motd
echo "  "`lsb_release -d` >> /etc/motd
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

printf "\nUseDNS no" >> /etc/ssh/sshd_config

sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

sed -i 's/# eval/eval/' ~/.bashrc
sed -i 's/# alias/alias/' ~/.bashrc
sed -i 's/#force_color/force_color/' /home/vagrant/.bashrc
sed -i 's/#alias/alias/' /home/vagrant/.bashrc

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo
echo "history -c && exit 0"
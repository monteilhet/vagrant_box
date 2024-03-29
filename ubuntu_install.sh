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

cp motd/02vagrant /etc/update-motd.d/
chmod 755 /etc/update-motd.d/02vagrant

CurrentDate=$(date +%Y-%m-%d)
sed -i s/yy-mm-dd/$CurrentDate/ /etc/update-motd.d/02vagrant

echo "vagrant  ALL=(ALL) NOPASSWD: ALL" >  /etc/sudoers.d/vagrant

#mkdir -p ~/.ssh
#chmod 700 ~/.ssh
#cp ssh/authorized_keys ~/.ssh
#chmod 600 ~/.ssh/authorized_keys

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cp ssh/authorized_keys /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh

printf "\nUseDNS no" >> /etc/ssh/sshd_config

sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

sed -i 's/#force_color/force_color/' ~/.bashrc
sed -i 's/#force_color/force_color/' /home/vagrant/.bashrc

sudo timedatectl set-timezone UTC

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo
echo "finish with :"
echo "> .bash_history && history -c && shutdown now"
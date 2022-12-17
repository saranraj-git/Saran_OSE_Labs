#!/bin/bash

# Author: SARANRAJ V

# To run this file 
# curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/asmt_solutions.sh | bash

# 1
sudo groupadd cricket
sudo useradd rohit
sudo useradd kohli
sudo useradd hardik 

echo "rohit:Secret123" >> pwdfile
echo "kohli:Secret123" >> pwdfile
#echo "hardik:Secret123" >> pwdfile

sudo chpasswd < pwdfile
rm -rf pwdfile

sudo usermod -a -G cricket rohit
sudo usermod -a -G cricket kohli
sudo usermod hardik -s /sbin/nologin


# 2
sudo cp /etc/hosts /mnt/
sudo chown root /mnt/hosts
sudo chgrp root /mnt/hosts   
sudo chmod 000 /mnt/hosts

# 3
sudo mkdir -p /open/source
sudo useradd jadeja
sudo chown jadeja /open/source
sudo chgrp cricket /open/source
sudo chmod 070 /open/source
sudo chmod g+s /open/source

# 4
sudo find / -user "jadeja" 1>/root/find.jadeja  2>/dev/null 
sudo chmod 755 /root/find.jadeja

#5
sudo useradd userdef
sudo useradd dravid

sudo echo "umask 0226" >> /home/userdef/.bashrc
sudo echo "umask 0226" >> /home/userdef/.bash_profile

sudo echo "umask 0227" >> /home/dravid/.bashrc
sudo echo "umask 0227" >> /home/dravid/.bash_profile



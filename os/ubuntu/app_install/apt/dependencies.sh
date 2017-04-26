#!/bin/bash
set -e
# libs-x86
sudo dpkg --add-architecture i386
# spotify-client
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
# gimp
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 614C4B38
# code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# virtualbox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
# libreoffice
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1378B444
# gnome3 extras
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B1510FD
# webupd8
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4C9D234C
# wine
sudo add-apt-repository -y ppa:wine/wine-builds

sudo apt-get update
sudo apt-get upgrade -y

# wine 
sudo apt-get install -y --install-recommends wine-staging
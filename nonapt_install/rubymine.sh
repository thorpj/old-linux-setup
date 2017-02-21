#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url=https://download.jetbrains.com/python/pycharm-professional-2016.3.2.tar.gz
app="rubymine"
filename=$(basename "$url")
dldir="/home/$SUDO_USER/.temp/"
wget $url -P $dldir
sudo mkdir /opt/$app
tar -xzf $dldir/$filename -C /opt/$app/
/opt/$app/bin/$app.sh
echo '$app has been installed'
echo '$app has been installed' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt

#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url=https://download.jetbrains.com/python/pycharm-professional-2016.3.2.tar.gz
app="webstorm"
filename=$(basename "$url")
dldir="/home/$SUDO_USER/.temp/"
wget $url -P $dldir
sudo mkdir /opt/$app
tar -xzf $dldir/$filename -C /opt/$app/
/opt/$app/bin/$app.sh || error="yes"
if [ $error = "yes" ]
    then
        echo '$app failed to install'
        echo '$app failed to install' >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
        exit
    else
        echo '$app has been installed'
        echo '$app has been installed' >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
fi
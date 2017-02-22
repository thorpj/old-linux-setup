#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url="http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb"
app="wps-office"
filename=$(basename "$url")
dldir="/home/$SUDO_USER/.temp/"
working_dir=$(pwd)
cd /home/$SUDO_USER/.temp/ && wget -O discord.deb $url
cd $working_dir
sudo dpkg -i $dldir/$app.deb || error="yes"
if [ $error = "yes" ]
    then
        echo '$app failed to install'
        echo '$app failed to install' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
    else
        echo '$app has been installed'
        echo '$app has been installed' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
fi


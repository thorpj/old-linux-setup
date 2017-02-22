#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url="https://discordapp.com/api/download?platform=linux&format=deb"
app="discord"
filename=$(basename "$url")
echo $filename
dldir="/home/$SUDO_USER/.temp/"
working_dir=$(pwd)
cd /home/$SUDO_USER/.temp/ && wget -O discord.deb $url
cd $working_dir
sudo dpkg -i $dldir/$app.deb || error="yes"
if [ $error = "yes" ]
    then
        echo '$app failed to install'
        echo '$app failed to install' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
        exit
    else
        echo '$app has been installed'
        echo '$app has been installed' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
fi
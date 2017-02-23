#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi

error ()
{
    application=$1
    error=$2
    if [ $error = "yes" ]
        then
            echo '$application failed to install'
            echo '$application failed to install' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
            exit
        else
            echo '$application has been installed'
            echo '$application has been installed' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
    fi
}

dldir="/home/$SUDO_USER/.temp/"

url="https://go.microsoft.com/fwlink/?LinkID=760868"
app="visual-studio-code"
wget $url -P $dldir -O $app.deb
error="no"
sudo dpkg -i $dldir/$app.deb || error="yes"
error $app $error


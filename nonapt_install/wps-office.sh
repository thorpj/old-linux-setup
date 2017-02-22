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


dep_1="ttf-mscorefonts-installer"
dep_1_error="no"
sudo apt install $dep_1 || dep_1_error="yes"
error $dep_1 $dep_1_error

dep_2_url="http://ftp.iinet.net.au/pub/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb"
dep_2="libpng12-0_x86-64"
wget $dep_2_url -P $dldir -O $dep_2.deb
dep_2_error="no"
sudo dpkg -i $dldir/$dep_2.deb || dep_2_error="yes"
error $dep_2 $dep_2_error

url="http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb"
app="wps-office"
wget $url -P $dldir -O $app.deb
error="no"
sudo dpkg -i $dldir/$app.deb || error="yes"
error $app $error


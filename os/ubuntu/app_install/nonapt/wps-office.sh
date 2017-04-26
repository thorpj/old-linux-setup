#!/bin/bash
dldir="$user_home/.temp/"

dep_error="no"
dep="ttf-mscorefonts-installer"
sudo apt install -y "$dep" || error="yes"

url="http://ftp.iinet.net.au/pub/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb"
dep="libpng12-0_x86-64"
wget $url -O "$dldir/$dep.deb"
sudo dpkg -i "$dldir/$dep.deb" || error_occurred="yes"

url="http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb"
app="wps-office"
wget $url -O "$dldir/$app.deb"
sudo dpkg -i "$dldir/$app.deb" || error_occurred="yes"

if [ "$error_occurred" = "yes" ]
    then
        echo "$application failed to install"
        echo "$application failed to install" >> "$loc_logfile"
        exit
    else
        echo "$application has been installed"
        echo "$application has been installed" >> "$loc_logfile"
fi
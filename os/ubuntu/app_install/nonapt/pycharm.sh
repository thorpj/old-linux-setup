#!/bin/bash
set -e

#Installing dependencies
sudo apt-get install -y openjdk-7-jdk git

url=https://download.jetbrains.com/python/pycharm-professional-2017.1.1.tar.gz

full_file_name="$0"
filename=$(basename "$full_file_name")
filename="${filename%.*}"
app="$filename"

# Get filename for this script
full_filename="${0##*/}"
filename=$(basename "$url")
dldir="/home/$SUDO_USER/.temp/"
wget $url -P $dldir
sudo mkdir /opt/$app
tar -xzf $dldir/$filename -C /opt/$app/
/opt/$app/bin/$app.sh || error="yes"
if [ $error = "yes" ]
    then
        echo '$app failed to install'
        echo '$app failed to install' >> "$loc_logfile"
        exit
    else
        echo '$app has been installed'
        echo '$app has been installed' >> "$loc_logfile"
fi

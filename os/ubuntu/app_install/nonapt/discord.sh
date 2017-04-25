#!/bin/bash
set -e
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url="https://discordapp.com/api/download?platform=linux&format=deb"

full_file_name="$0"
filename=$(basename "$full_file_name")
filename="${filename%.*}"
app="$filename"

filename=$(basename "$url")
echo $filename
dldir="/home/$SUDO_USER/.temp/"
working_dir=$(pwd)
cd /home/$SUDO_USER/.temp/ && wget -O discord.deb $url
cd $working_dir
sudo dpkg -i $dldir/$app.deb || error="yes"
if [ $error = "yes" ]
    then
        echo "$app failed to install"
        echo "$app failed to install" >> "$loc_logfile"
        exit
    else
        echo "$app has been installed"
        echo "$app has been installed" >> "$loc_logfile"
fi
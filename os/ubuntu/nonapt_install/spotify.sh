#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi

error ()
{
    application=$1
    error_occurred=$2
    if [ $error_occurred = "yes" ]
        then
            echo '$application failed to install'
            echo '$application failed to install' >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
            exit
        else
            echo '$application has been installed'
            echo '$application has been installed' >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
    fi
}

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client || error_occurred="yes"
error "spotify" $error_occurred
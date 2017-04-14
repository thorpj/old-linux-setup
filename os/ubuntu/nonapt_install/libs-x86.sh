#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi

error ()
{
    error_occurred=$1
    if [ $error_occurred = "yes" ]
        then
            echo 'An error occurred, possibly due to attempts to install 32bit libraries'
            echo 'An error occurred, possibly due to attempts to install 32bit libraries' >> /home/$SUDO_USER/git/os-setup/os/ubuntu/log.txt
            exit
        else
            echo 'apt upgrade succedded. 32bit libaries installed successfully'
            echo 'apt upgrade succedded. 32bit libaries installed successfully' >> /home/$SUDO_USER/git/os-setup/os/ubuntu/log.txt
    fi
}

sudo dpkg --add-architecture i386
sudo apt update
error_occurred="no"
sudo apt upgrade -y || error_occurred="yes"
error $error_occurred
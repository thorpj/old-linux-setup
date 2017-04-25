#!/bin/bash
set -e
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo mkdir -p $user_name/.config/autostart/
sudo cp "$loc_app_list/apt/albert.desktop" $user_name/.config/autostart/
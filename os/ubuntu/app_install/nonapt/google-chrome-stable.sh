#!/bin/bash
sudo apt-get update
sudo apt-get install -y libgconf2-4 libnss3-1d libxss1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$user_home/.temp/google-chrome-stable_current_amd64.deb"
sudo dpkg -i "$user_home/.temp/google-chrome-stable_current_amd64.deb"
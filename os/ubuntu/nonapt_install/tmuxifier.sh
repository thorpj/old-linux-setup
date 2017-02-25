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

dldir="/home/$SUDO_USER/.temp/"

url="https://go.microsoft.com/fwlink/?LinkID=760868"
app="visual-studio-code"
wget $url -P $dldir -O $app.deb
error_occurred="no"
sudo dpkg -i $dldir/$app.deb || error_occurred="yes"
error $app $error_occurred

git clone https://github.com/jimeh/tmuxifier.git /home/$SUDO_USER/.tmuxifier
echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> /home/$SUDO_USER/.bashrc
# echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> /home/$SUDO_USER/.profile
echo 'eval "$(tmuxifier init -)"' >> /home/$SUDO_USER/.profile
echo "tmuxa='tmuxifier load-window four_squares'" >> /home/$SUDO_USER/.bashrc
echo "tmuxb='tmuxifier load-window two_squares'" >> /home/$SUDO_USER/.bashrc
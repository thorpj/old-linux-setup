#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
url="https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-ia32-4.0.4.tgz"
app="franz"
filename=$(basename "$url")
dldir="/home/$SUDO_USER/.temp/"
wget $url -P $dldir
sudo mkdir /opt/$app
tar -xzf $dldir/$filename -C /opt/$app/
sudo touch /usr/share/applications/$app.desktop
sudo echo -e '[Desktop Entry]\nName=Franz\nComment=\nExec=/opt/franz/Franz\nIcon=/opt/franz/franz-icon.png\nTerminal=false\nType=Application\nCategories=Messaging,Internet' > /usr/share/applications/$app.desktop
echo '$app has been installed'
echo '$app has been installed' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt

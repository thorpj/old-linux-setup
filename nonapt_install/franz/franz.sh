#!/bin/bash
url=https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-ia32-4.0.4.tgz
filename=$(basename "$url")
dldir=/home/$SUDO_USER/.temp/
wget $url -P $dldir
sudo mkdir /opt/franz1
tar -xzf $dldir/$filename -C /opt/franz1/
sudo touch /usr/share/applications/franz.desktop
sudo echo -e '[Desktop Entry]\nName=Franz\nComment=\nExec=/opt/franz/Franz\nIcon=/opt/franz/franz-icon.png\nTerminal=false\nType=Application\nCategories=Messaging,Internet' > /usr/share/applications/franz.desktop
#!/bin/bash
gnome_version=$(gnome-shell --version)
gnome_version=${gnome_version:12:4}
echo $gnome_version

python /home/$SUDO_USER/Git/OS-Setup/extensions.py 3.18

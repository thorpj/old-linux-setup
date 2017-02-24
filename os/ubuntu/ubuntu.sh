#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
cd /home/$SUDO_USER/Git/OS-Setup/os/ubuntu
askyesno ()
{
    question=$1
    default=$2
    if [ "$default" = true ]; then
            options="[Y/n]"
            default="y"
        else
            options="[y/N]"
            default="n"
    fi
    read -p "$question $options " -n 1 -s -r input
    input=${input:-${default}}
    echo ${input}
    if [[ "$input" =~ ^[yY]$ ]]; then
        result=true
    else
        result=false
    fi
}

error ()
{
    appname="$1"
    error_occurred="$2"
    if [ "$error_occurred" = "yes" ]
        then
            echo "ERROR: $appname failed to install"
            echo "ERROR: $appname failed to install" >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
        else
            echo "INFO: $appname installed successfully"
            echo "INFO: $appname installed successfully" >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
    fi
}

askyesno "Have you configured apt_package_list.txt, nonapt_package_list.txt, bashrc_aliases.txt and authorized_keys.txt? " true
if [ "$result" != true ]
    then
        echo "Please configure those files, which are located in /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/"
        exit
fi

apt_install ()
{
    sudo apt update
    apt_list=$'\n' read -d '' -r -a lines < apt_package_list.txt
    for app_apt in "${lines[@]}"
    do
        if [[ ${app:0:1} == "#" ]]
            then
                :
            else
                if [ $app == "google-chrome-stable" ]
                    then
                        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
                        sudo apt update
                    else
                        :
                fi
                install_error="no"
                sudo apt install $app_apt || install_error="yes"
                error "$app_apt" "$install_error"
        fi
done
}


authorized_keys ()
{
    cat 'authorized_keys.txt' >> $HOME/.ssh/authorized_keys
}

edit_bashrc ()
{
    cat 'bashrc_alises.txt' >> /home/$SUDO_USER/.bashrc
}

nonapt_install ()
{
    nonapt_list=$'\n' read -d '' -r -a nonapt < nonapt_package_list.txt
    cd /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/nonapt_install/
    for app_nonapt in "${nonapt[@]}"
    do
        if [[ ${app:0:1} == "#" ]]
            then
                :
            else
                install_error="no"
                sudo $app_nonapt.sh || install_error="yes"
                error "$app_nonapt" "$install_error"
        fi
    done
    cd /home/$SUDO_USER/Git/OS-Setup/os/ubuntu
}

gnome_install ()
{
    error_occurred="no"
    python2 /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/gnome-shell-extensions.py || error_occurred="yes"
    error "gnome-shell-extensions" $error_occurred
}

configuration ()
{
    sudo chown root:root /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout
    sudo chmod 0440 /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout
    sudo cp /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout /etc/sudoers.d/

}

cleanup ()
{
    :
    """
    * Once finished, tell user to view apt_package_list.txt and nonapt_package_list.txt list to see what they should add to the taskbar
    * Delete files from ~/.temp
    * POST INSTALL NOTES
        * How to setup tmuxifier
    * gnome extensions need to be configured
    """
    sudo rm /etc/sudoers.d/extend_sudo_timeout
}


Main ()
{
    askyesno "Install apt apps? " true
    if [ "$result" = true ]; then
        apt_install
    fi
    askyesno "Install nonapt apps? " true
    if [ "$result" = true ]; then
        apt_install
    fi
    askyesno "Install Gnome extensions?" true
    if [ "$result" = true ]; then
        gnome_install
    fi
    askyesno "Append contents of authorized_keys.txt to ~/.ssh/authorized_keys? " true
    if [ "$result" = true ]; then
        authorized_keys
    fi
    askyesno "Append contents of bashrc_alises.txt to ~/.bashrc? " true
    if [ "$result" = true ]; then
        edit_bashrc
    fi
    askyesno "Configure system? " true
    if [ "$result" = true ]; then
        configuration
    fi
    cleanup
}
Main


#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
cd /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu
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


apt_install ()
{
    apt_list=$'\n' read -d '' -r -a lines < apt_package_list.txt

    for app_apt in "${lines[@]}"
    do
        if [[ ${app:0:1} == "#" ]]
            then
                :
            else
                sudo apt install $app_apt || echo '$app failed to install' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
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
    cd /home/$SUDO_USER/Git/OS-Setup/nonapt_install/
    for app_nonapt in "${nonapt[@]}"
    do
        if [[ ${app:0:1} == "#" ]]
            then
                :
            else
                sudo $app_nonapt.sh || echo '$app failed to install' >> /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu/log.txt
        fi
    done
    cd /home/$SUDO_USER/Git/OS-Setup/OS/ubuntu
}

configuration ()
{
    :
}





Main ()
{
#    askyesno "Install apt apps? " true
#    if [ "$result" = true ]; then
#        apt_install
#    fi
#    askyesno "Append contents of authorized_keys.txt to ~/.ssh/authorized_keys? " true
#    if [ "$result" = true ]; then
#        authorized_keys
#    fi
#    askyesno "Append contents of bashrc_alises.txt to ~/.bashrc? " true
#    if [ "$result" = true ]; then
#        edit_bashrc
#    fi
}
Main


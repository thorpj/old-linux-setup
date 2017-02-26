#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
cd $HOME/git/OS-Setup/os/ubuntu
sudo chown root:root $HOME/git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout
sudo chmod 0440 $HOME/git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout
sudo cp $HOME/git/OS-Setup/os/ubuntu/configuration/extend_sudo_timeout /etc/sudoers.d/
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

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
            echo "ERROR: $appname failed to install" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
        else
            echo "INFO: $appname installed successfully"
            echo "INFO: $appname installed successfully" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
    fi
}

askyesno "Have you configured apt_package_list.txt, nonapt_package_list.txt, aliases_list.txt and authorized_keys.txt? " true
if [ "$result" != true ]
    then
        echo "Please configure those files, which are located in $HOME/git/OS-Setup/os/ubuntu/"
        exit
fi

apt_install ()
{
    ubuntu_codename=$(grep $(lsb_release -rs) /usr/share/python-apt/templates/Ubuntu.info | grep -m 1 "Description: Ubuntu " | cut -d "'" -f2)
    IFS=' ' read -a ubuntu_codename_parts <<< "$ubuntu_codename"
    ubuntu_codename=${ubuntu_codename_parts,,}
    sudo echo "deb http://archive.canonical.com/ubuntu $ubuntu_codename partner" >> /etc/apt/sources.list
    sudo echo "deb-src http://archive.canonical.com/ubuntu $ubuntu_codename partner" >> /etc/apt/sources.list
    sudo echo "deb http://download.virtualbox.org/virtualbox/debian $ubuntu_codename contrib" >> /etc/apt/sources.list
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-add-repository -y ppa:wine/wine-builds
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt update
    sudo apt upgrade -y
    sudo apt-get install -y --install-recommends winehq-devel
    mkdir -p $HOME/.config/autostart/
    sudo cp $HOME/git/OS-Setup/os/ubuntu/nonapt_install/albert.desktop $HOME/.config/autostart/
    apt_list=$'\n' read -d '' -r -a lines < apt_package_list.txt
    for app_apt in "${lines[@]}"
    do
        if [[ ${app_apt:0:1} == "#" ]]
            then
                :
            else
                if [ "$app_apt" = "google-chrome-stable" ]
                    then
                        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
                        sudo apt update
                    else
                        :
                fi
                install_error="no"
                sudo apt install -y $app_apt || install_error="yes"
                error "$app_apt" "$install_error"
                if [ "$app_apt" = "tmux" ]
                    then
                        touch $HOME/.tmux.conf
                        echo 'set-option -g prefix C-a' > $HOME/.tmux.conf
                        tmux source-file $HOME/.tmux.conf
                        cd $HOME
                        git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
                        echo 'eval "$(tmuxifier init -)"' >> ~/.profile
                        echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> $HOME/.bashrc
                        echo "tmuxa='tmuxifier load-window tmux_a'" >> $HOME/.bashrc
                        echo "tmuxb='tmuxifier load-window tmux_b'" >> $HOME/.bashrc
                        mkdir -p $HOME/.tmuxifier/layouts
                        echo -e "new_window \"tmux_a\"\nsplit_v 50 0\nsplit_h 50 0\nsplit_h 50 1" > $HOME/.tmuxifier/layouts/tmux_a.window.sh
                        echo -e "new_window \"tmux_a\"\nsplit_h 50 0" > $HOME/.tmuxifier/layouts/tmux_b.window.sh
                fi
        fi

done
}


authorized_keys ()
{
    cat 'authorized_keys.txt' >> $HOME/.ssh/authorized_keys
}

edit_bashrc ()
{
    cat "$HOME/git/OS-Setup/os/ubuntu/aliases_list.txt" >> $HOME/.bashrc
    for file in $HOME/git/Linux-Scripts/*.sh
        do
            file=$(basename $file)
            name=${file%.sh}
            name=${name##*/}
            echo "alias $name='$HOME/git/Linux-Scripts/$file'" >> $HOME/.bashrc
    done
    askyesno "Are you using WSL (Windows Subsystem for Linux) and cbwin?" false
    if [ "$result" = true ]; then
        echo "alias code='wrun \"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe\"'" >> $HOME/.bashrc
    fi
}

nonapt_install ()
{
    nonapt_list=$'\n' read -d '' -r -a nonapt < $HOME/git/OS-Setup/os/ubuntu/nonapt_package_list.txt
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
}

gnome_install ()
{
    error_occurred="no"
    python2 $HOME/git/OS-Setup/os/ubuntu/gnome-shell-extensions.py || error_occurred="yes"
    error "gnome-shell-extensions" $error_occurred
}

configuration ()
{
    gsettings_list=$'\n' read -d '' -r -a gsettings < $HOME/git/OS-Setup/os/ubuntu/configuration/gsettings/$ubuntu_codename
    if [ ! -f $HOME/git/OS-Setup/os/ubuntu/configuration/gsettings/$ubuntu_codename ]
        then
            echo "It is not possible to import gsettings because a configuration file for your version of Ubuntu does not exist"
            echo "It is not possible to import gsettings because a configuration file for your version of Ubuntu does not exist" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
        else
            for gsetting in "${gsettings[@]}"
                do
                    gsettings set $gsetting
                done
    fi
    if [ ! -f $HOME/git/OS-Setup/os/ubuntu/configuration/dconf/$ubuntu_codename ]
        then
            dconf load / < $HOME/git/OS-Setup/os/ubuntu/configuration/dconf/$ubuntu_codename
        else
            echo "It is not possible to import dconf settings because a configuration file for your version of Ubuntu does not exist"
            echo "It is not possible to import dconf settings because a configuration file for your version of Ubuntu does not exist" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
    fi

}

cleanup ()
{
    """
    * Once finished, tell user to view apt_package_list.txt and nonapt_package_list.txt list to see what they should add to the taskbar
    * Delete files from ~/.temp
    * POST INSTALL NOTES
        * How to setup tmuxifier
    * gnome extensions need to be configured
    """
    sudo rm -rf $HOME/.temp
    rm -f $HOME/init.sh
    sudo /sbin/shutdown -r -t 10
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
    sudo rm /etc/sudoers.d/extend_sudo_timeout
}


Main ()
{
    askyesno "Install apt apps? " true
    if [ "$result" = true ]; then
        apt_install_yes=true
    fi
    askyesno "Install nonapt apps? " true
    if [ "$result" = true ]; then
        nonapt_install_yes=true
    fi
    askyesno "Install Gnome extensions?" true
    if [ "$result" = true ]; then
        gnome_install_yes=true
    fi
    askyesno "Append contents of authorized_keys.txt to ~/.ssh/authorized_keys? " true
    if [ "$result" = true ]; then
        authorized_keys_yes=true
    fi
    askyesno "Append contents of aliases_list.txt to ~/.bashrc? " true
    if [ "$result" = true ]; then
        edit_bashrc_yes=true
    fi
    askyesno "Configure system? " true
    if [ "$result" = true ]; then
        configuration_yes=true
    fi

    if [ "$apt_install_yes" = true ]; then
        apt_install
    fi
    if [ "$nonapt_install_yes" = true ]; then
        nonapt_install
    fi
    if [ "$gnome_install_yes" = true ]; then
        gnome_install
    fi
    if [ "$authorized_keys_yes" = true ]; then
        authorized_keys
    fi
    if [ "$edit_bashrc_yes" = true ]; then
        edit_bashrc
    fi
    if [ "$configuration_yes" = true ]; then
        configuration
    fi
    cleanup
}
Main


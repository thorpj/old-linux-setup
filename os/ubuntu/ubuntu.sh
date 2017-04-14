#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
cd $HOME/git/os-setup/os/ubuntu
echo "The sudo timeout will be set to 15 minutes. It will be reset once the script has finished"
sudo chown root:root $HOME/git/os-setup/os/ubuntu/configuration/extend_sudo_timeout
sudo chmod 0440 $HOME/git/os-setup/os/ubuntu/configuration/extend_sudo_timeout
sudo cp $HOME/git/os-setup/os/ubuntu/configuration/extend_sudo_timeout /etc/sudoers.d/
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
            echo "ERROR: "$appname" failed to install"
            echo "ERROR: "$appname" failed to install" >> $HOME/git/os-setup/os/ubuntu/log.txt
        else
            echo "INFO: "$appname" installed successfully"
            echo "INFO: "$appname" installed successfully" >> $HOME/git/os-setup/os/ubuntu/log.txt
    fi
}

askyesno "Have you configured apt_package_list.txt, nonapt_package_list.txt, aliases_list.txt and authorized_keys.txt? " true
if [ "$result" != true ]
    then
        echo "Please configure those files, which are located in $HOME/git/os-setup/os/ubuntu/"
        exit
fi

apt_install ()
{
    # Get ubuntu version (codename). e.g. 'Trusty' for Ubuntu 14.04
    ubuntu_codename="$(grep $(lsb_release -rs) /usr/share/python-apt/templates/Ubuntu.info | grep -m 1 "Description: Ubuntu " | cut -d "'" -f2)"
    IFS=' ' read -a ubuntu_codename_parts <<< "$ubuntu_codename"
    ubuntu_codename="${ubuntu_codename_parts,,}"
    # Add sources for apt
    echo "deb http://archive.canonical.com/ubuntu $ubuntu_codename partner" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "deb-src http://archive.canonical.com/ubuntu $ubuntu_codename partner" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "deb http://download.virtualbox.org/virtualbox/debian $ubuntu_codename contrib" | sudo tee -a /etc/apt/sources.list > /dev/null
    
    # webupd8 is for TODO=====================================================================================================================================================================================================
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-add-repository -y ppa:wine/wine-builds
    
    # Add sources for Virtualbox
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt update
    sudo apt upgrade -y
    
    # Install wine developer version
    sudo apt-get install -y --install-recommends winehq-devel
    mkdir -p $HOME/.config/autostart/
    
    # Albert is a launcher program
    sudo cp $HOME/git/os-setup/os/ubuntu/nonapt_install/albert.desktop $HOME/.config/autostart/
    
    apt_list=$'\n' read -d '' -r -a lines < apt_package_list.txt
    for app_apt in "${lines[@]}"  # Install programs with apt repos
    do
        if [[ ${app_apt:0:1} == "#" ]]
            then
                :
            else
                if [ "$app_apt" = "google-chrome-stable" ]
                    then
                        # deb setup for Google Chrome Stable
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
                        # Install tmux
                        touch $HOME/.tmux.conf
                        echo 'set-option -g prefix C-a' > $HOME/.tmux.conf
                        tmux source-file $HOME/.tmux.conf
                        cd $HOME
                        git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
                        echo 'eval "$(tmuxifier init -)"' >> ~/.profile
                        echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> $HOME/.bashrc
                        echo "alias tmuxa='tmuxifier load-window tmux_a'" >> $HOME/.bashrc
                        echo "alias tmuxb='tmuxifier load-window tmux_b'" >> $HOME/.bashrc
                        echo "alias tmuxc='tmuxifier load-window tmux_c'" >> $HOME/.bashrc
                        mkdir -p $HOME/.tmuxifier/layouts
                        echo -e "new_window \"tmux_a\"\nsplit_v 50 0\nsplit_h 50 0\nsplit_h 50 1" > $HOME/.tmuxifier/layouts/tmux_a.window.sh
                        echo -e "new_window \"tmux_b\"\nsplit_h 50 0" > $HOME/.tmuxifier/layouts/tmux_b.window.sh
                        echo -e "new_window \"tmux_c\"\nsplit_v 50 0" > $HOME/.tmuxifier/layouts/tmux_c.window.sh
                fi
        fi
done
}


authorized_keys ()
{
    cat 'authorized_keys.txt' >> $HOME/.ssh/authorized_keys
}

# edit_bashrc ()
# {
#     cat "$HOME/git/os-setup/os/ubuntu/aliases_list.txt" >> $HOME/.bashrc
#     for file in $HOME/git/Linux-Scripts/*.sh
#         do
#             file=$(basename $file)
#             name=${file%.sh}
#             name=${name##*/}
#             echo "alias $name='$HOME/git/Linux-Scripts/$file'" >> $HOME/.bashrc
#     done
#     askyesno "Are you using WSL (Windows Subsystem for Linux) and cbwin?" false
#     if [ "$result" = true ]; then
#         echo "alias code='wrun \"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe\"'" >> $HOME/.bashrc
#     fi
# }

edit_bashrc ()
{
#     cat "$HOME/git/os-setup/os/ubuntu/aliases_list.txt" >> $HOME/.bashrc
#     for file in $HOME/git/linux-scripts/*.sh
    path="$HOME/git/Linux-Scripts/"
    alias_short="#aliases_list"
    if [ ! -z "$(grep "$alias_short" $HOME/.bashrc)" ]
        then
            :
        else
            cat "$path/aliases_list.txt" >> $HOME/.bashrc
    fi
    for file in $HOME/git/Linux-Scripts/*.sh
        do
            file=$(basename $file)
            name=${file%.sh}
            name=${name##*/}
            alias="alias $name='$HOME/git/Linux-Scripts/$file'"
            if [ ! -z "$(grep "$file" $HOME/.bashrc)" ]
                then
                    :
                else
                    echo $alias >> $HOME/.bashrc
            fi
    done
    askyesno "Are you using WSL (Windows Subsystem for Linux) and cbwin?" false
    if [ "$result" = true ]; then
        alias="alias code='wrun \"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe\"'"
        alias_short="alias code"
        if [ ! -z "$(grep "$alias_short" $HOME/.bashrc)" ]
            then
                :
            else
                echo $alias >> $HOME/.bashrc
        fi
        alias="alias cd_c='cd /mnt/c'"
        alias_short="alias cd_c"
        if [ ! -z "$(grep "$alias_short" $HOME/.bashrc)" ]
            then
                :
            else
                echo $alias >> $HOME/.bashrc
        fi
        alias="alias cd_d='cd /mnt/d'"
        alias_short="alias cd_d"
        if [ ! -z "$(grep "$alias_short" $HOME/.bashrc)" ]
            then
                :
            else
                echo $alias >> $HOME/.bashrc
        fi
    fi
    . $HOME/.bashrc
}

nonapt_install ()
{
    nonapt_list=$'\n' read -d '' -r -a nonapt < $HOME/git/os-setup/os/ubuntu/nonapt_package_list.txt
    for app_nonapt in "${nonapt[@]}"
    do
        if [[ ${app_nonapt:0:1} == "#" ]]  # Prevents installing programs that have have an '#' in front of the name
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
    python2 $HOME/git/os-setup/os/ubuntu/gnome-shell-extensions.py || error_occurred="yes"
    error "gnome-shell-extensions" $error_occurred
}

configuration ()
{
    gsettings_list=$'\n' read -d '' -r -a gsettings < $HOME/git/os-setup/os/ubuntu/configuration/gsettings/$ubuntu_codename
    if [ ! -f $HOME/git/os-setup/os/ubuntu/configuration/gsettings/$ubuntu_codename ]
        then
            echo "It is not possible to import gsettings because a configuration file for your version of Ubuntu does not exist"
            echo "It is not possible to import gsettings because a configuration file for your version of Ubuntu does not exist" >> $HOME/git/os-setup/os/ubuntu/log.txt
        else
            for gsetting in "${gsettings[@]}"
                do
                    gsettings set $gsetting
                done
    fi
    if [ ! -f $HOME/git/os-setup/os/ubuntu/configuration/dconf/$ubuntu_codename ]
        then
            dconf load / < $HOME/git/os-setup/os/ubuntu/configuration/dconf/$ubuntu_codename
        else
            echo "It is not possible to import dconf settings because a configuration file for your version of Ubuntu does not exist"
            echo "It is not possible to import dconf settings because a configuration file for your version of Ubuntu does not exist" >> $HOME/git/os-setup/os/ubuntu/log.txt
    fi

}

cleanup ()
{
    sudo rm -rf $HOME/.temp
    sudo rm -f $HOME/init.sh
    echo "Rebooting in 10 seconds. Do not interupt."
    sudo /sbin/shutdown -r -t 10
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
    sudo rm /etc/sudoers.d/extend_sudo_timeout
}


Main ()
{
    askyesno "Install apt apps? " true
    if [ $result = true ]; then
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

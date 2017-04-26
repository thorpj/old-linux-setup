#!/bin/bash
pwd

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
rm "$loc_logfile"
touch "$loc_logfile"

# Get ubuntu version (codename). e.g. 'Trusty' for Ubuntu 14.04
ubuntu_codename="$(grep $(lsb_release -rs) /usr/share/python-apt/templates/Ubuntu.info | grep -m 1 "Description: Ubuntu " | cut -d "'" -f2)"
IFS=' ' read -a ubuntu_codename_parts <<< "$ubuntu_codename"
ubuntu_codename="${ubuntu_codename_parts,,}"

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

app_installed_log ()
{
    appname="$1"
    echo "INFO: "$appname" installed successfully"
    echo "INFO: "$appname" installed successfully" >> "$loc_logfile"
}

log_entry ()
{
    log_text="$1"
    echo "$log_text"
    echo "$log_text" >> "$loc_logfile"
}

app_install ()
{
    
    
    # Add sources for apt
    sed -i "s|ubuntu_codename|$ubuntu_codename|g" "$loc_app_install_dir/apt/sources.txt"
    sudo mv "$loc_app_install_dir/apt/sources.txt" "/etc/apt/sources.list"
    source "$loc_app_install_dir/apt/dependencies.sh"

    # install apt apps
    apt_list=$'\n' read -d '' -r -a lines < "$loc_app_install_dir/app_list.txt"
    for apt_app in "${lines[@]}"; do
        if [ "$apt_app" = "#===non_apt===" ]; then
            break
        fi
        if [[ "${apt_app:0:1}" == "#" ]] || [[ "${file:0:1}" == "" ]; then
            continue
        else
            sudo apt-get install -y "$apt_app"
            app_installed_log "$apt_app"
        fi
    done

    # install nonapt apps
    for app in "$loc_app_list/nonapt/*.sh"; do
        if [[ "${app:0:1}" == "#" ]] || [[ "${app:0:1}" == "" ]]; then
            continue
        else
            sudo bash "$loc_app_list/nonapt/$app"
            app_installed_log "$app"
    done

gnome_extensions_install ()
{
    python2 "$loc_repo_os/configuration/gnome-shell-extensions.py" 
    app_installed_log "gnome-shell-extensions"
    gnome_version="$(gnome-shell --version)"
    gnome_version="${gnome_version//GNOME}"
    gnome_version="${gnome_version//Shell}"
}

configuration ()
{
    gsettings_list=$'\n' read -d '' -r -a gsettings < "$loc_repo_os/configuration/gsettings/$ubuntu_codename"
    if [ ! -f "$loc_repo_os/configuration/gsettings/$ubuntu_codename" ]
        then
            log_entry "It is not possible to import gsettings because a configuration file for your version of Ubuntu does not exist"
        else
            for gsetting in "${gsettings[@]}"
                do
                    gsettings set $gsetting
                done
    fi
    if [ ! -f "$loc_repo_os/configuration/dconf/$ubuntu_codename" ]
        then
            dconf load / < "$loc_repo_os/configuration/dconf/$ubuntu_codename"
        else
            log_entry "It is not possible to import dconf settings because a configuration file for your version of Ubuntu does not exist"
    fi

}

cleanup ()
{
    sudo rm -rf $user_home/.temp
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
    sudo rm /etc/sudoers.d/extend_sudo_timeout
    read "Press ENTER to reboot"
    sudo /sbin/shutdown -r -t 1
}


Main ()
{
    source "$loc_repo/sens_variables.sh"
    source "$loc_repo/variables.sh"

    git clone git@github.com:thorpj/linux-scripts.git "$loc_git/linux-scripts"
    
    echo "The sudo timeout will be set to 15 minutes. It will be reset once the script has finished"
    sudo chown root:root "$loc_repo_os/configuration/extend_sudo_timeout" 
    sudo chmod 0440 "$loc_repo_os/configuration/extend_sudo_timeout" 
    sudo cp "$loc_repo_os/configuration/extend_sudo_timeout" /etc/sudoers.d/
    
    echo "The sleep timeout will be disabled. It will be reset once the script has finished"
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    
    app_install
    mv "$loc_repo/vscode_${device_type}_settings.txt" "$user_home/.config/Code/User/settings.json"
    gnome_extensions_install
    cat "$loc_repo/authorized_keys.txt" >> "$user_home/.ssh/authorized_keys"
    if grep -Fxq $user_home/.ssh/${device_name}.pub "$user_home/.ssh/authorized_keys"; then
        :
    else
        cat "$user_home/.ssh/${device_name}.pub" >> "$loc_repo/authorized_keys.txt"
        cd "$loc_repo"
        git add "$loc_repo/authorized_keys.txt"
        git commit -m "adding public key for $device_name"
        git push origin master
        cd "$user_home"
    bash "$loc_bashrc_aliases"
    source "$loc_repo/clone_repos.sh"
    configuration
    cleanup
}
Main

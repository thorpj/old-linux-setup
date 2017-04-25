#!/bin/bash
source ./sens_variables.sh


# Base variables
user_name="$USER"
user_home="/home/$user_name" ##
loc_git="$user_home/git" #
loc_unigit="$user_home/uni-git" #
device_name="SB-UB174-1" # options: See https://freedcamp.com/Misc_2yL/Device_Maintenan_ppw/todos
device_type="laptop"
os_name="ubuntu" # options: ubuntu
ssh_key_name="$device_name"
loc_wsl_repos="/mnt/c"

# Repo locations
loc_repo="/home/$USER/git/linux-setup"
loc_repo_os="$loc_repo/os/$os_name"
loc_extend_sudo_timeout="$loc_repo/"
loc_logfile="$loc_repo_os/log.log"
loc_authorized_keys_list="$loc_repo/authorized_keys.txt"
loc_app_install_dir="$loc_repo_os/app_install"
loc_configuration_dir="$loc_repo_os/configuration"


# External script locations
loc_linux_scripts="$loc_git/linux-scripts"
loc_bashrc_aliases="$loc_linux_scripts/bahrc_aliases.sh"
loc_aliases_list="$loc_linux_scripts/aliases_list.txt"
loc_clone_repos="$loc_linux_scripts/clone_repos.sh"

#!/bin/bash

# if [ "$github_token" = "" ]; then
#     printf "The environment variable github_token has not been set.\n1) Visit https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/ on creating a personal access token.\n2) add 'export github_token=*personal access token*' to ~/.bashrc\n"
#     printf "Exiting...\n"
#     exit
# fi

askyesno ()
#Ask if user wishes to continue with given action. Can set default to yes or no
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
    read -p "$question $options " -r input
    input=${input:-${default}}
    if [[ "$input" =~ ^[yY]$ ]]; then
        result="true"
    else
        result="false"
    fi
}

if [ "$USER" = "root" ]; then
    askyesno "WARNING: User is root. Do you wish to continue?" true
    if [ "$result" != "true"]; then
        exit
    fi
fi

initial_setup ()
# Check if dependencies are met
{
    if dpkg-query -W -f'${Status}' "git" 2>/dev/null | grep -q "ok installed"; then
        :
    else
        echo "git is not installed. Installing..."
        sudo apt-get -q update
        sudo apt-get install -y -q git 
    fi
    if dpkg-query -W -f'${Status}' "curl" 2>/dev/null | grep -q "ok installed"; then
        :
    else
        echo "curl is not installed. Installing..."
        sudo apt-get -q update
        sudo apt-get install -y -q curl
    fi
}

git_setup ()
# Checks if user's git username and email are correct. Fixes it if necessary.
{
    current_github_user=$(git config --global user.name)
    current_github_email=$(git config --global user.email)
    
    askyesno "Is \"$current_github_user\" the correct username? (If username shown is blank, select no)" true
    if [ "$result" = "true" ]; then
            github_user="$current_github_user"
    else
            read -p "Github username: " github_user
            git config --global user.name "$github_user"
    fi
    while [ -z "$current_github_user" ]; do
            read -p "Github username: " github_user
            git config --global user.name "$github_user"
    done

    askyesno "Is \"$current_github_email\" the correct email? (If email shown is blank, select no)" true
    if [ "$result" = "true" ]; then
        github_email="$current_github_email"
    else
        read -p "Github email: " github_email
        git config --global user.name "$github_email"
    fi
    while [ -z "$github_email" ]; do
        read -p "Github email: " github_email
        git config --global user.name "$github_email"
    done
    sudo mkdir -p "$HOME/git"
    sudo mkdir -p "$HOME/uni-git"
}

ssh_key_setup ()
{
    if [ -z "$github_token" ] || [ -z "$device_name" ] || [ -z "$os_name" ] || [ -z "$github_user" ] || [ -z "$github_email" ] || [ -z "$user_name" ] || [ -z "$ssh_key_name" ]; then
        echo "===== SSH Key Setup ====="
        read -p "Personal access token" github_token
        read -p "Device name (HW): " device_name
        read -p "OS: " os_name
        user_name="$USER"
        ssh_key_name="id_rsa"
    fi
    key_title="${device_name}_${os_name}_${user_name}"
    ssh-keygen -t rsa -N "" -f "$user_home/.ssh/$ssh_key_name" -C "$github_email"
    ssh_key="$(cat "$HOME/.ssh/${ssh_key_name}.pub")"
    curl -u "$github_user:$github_token" --data "{\"title\":\"$key_title\",\"key\":\"$ssh_key\"}" "https://api.github.com/user/keys"
}

main ()
{
    initial_setup
    if [ -z "$github_user" ] || [ -z "$github_email" ]; then
        git_setup
    fi
    ssh_key_setup
}
main
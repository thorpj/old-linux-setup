#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
printf "\n"
if dpkg --get-selections | grep -q "^curl[[:space:]]*install$" >/dev/null; then
    echo "Info: Curl is already installed"
else
    apt install curl
    echo "Info: Curl has finished installing"
fi


select_distro ()
{
    printf "\n"
    PS3='Select your OS: '
    options=("Linux")
    select opt in "${options[@]}"
    do
        case $opt in
        "Ubuntu")
            cd ./OS/Ubuntu
            ./Ubuntu.sh
            break
            ;;
        *)
            echo "Invalid"
            select_distro
            ;;
        esac
    done
}


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


git_clone ()
{
    askyesno "Would you like to add your devices public SSH key to Github? " true
    if [ "$result" = true ]; then
        read -p "SSH key: " ssh_key
        read -p "Username: " username
        read -p "Password: " password
        read -p "Email: " email
        curl -u "$username:$password" --data '{"title":"$email","key":"$ssh_key"}' https://api.github.com/user/keys
    fi
    git clone git@github.com:thorpj/Linux-Applications.git
    git clone git@github.com:thorpj/Linux-Scripts.git
}


Main ()
{
    git_clone
    select_distro
}
Main

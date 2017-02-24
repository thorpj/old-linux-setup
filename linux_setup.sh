#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
if [ "$(uname -m)" = "x86_64" ]
    then
        :
    else
        echo "32bit systems are not supported... exiting..."
        exit
fi
mkdir /home/$SUDO_USER/.temp
mkdir /home/$SUDO_USER/Git
cd /home/$SUDO_USER/Git/OS-Setup/


error ()
{
    appname="$1"
    error_occurred="$2"
    if [ "$error_occurred" = "yes" ]
        then
            echo "$appname failed to install"
            echo "$appname failed to install" >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
        else
            echo "$appname installed successfully"
            echo "$appname installed successfully" >> /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/log.txt
    fi


}

printf "\n"
if dpkg --get-selections | grep -q "^curl[[:space:]]*install$" >/dev/null; then
    echo "Info: Curl is already installed"
else
    curl_error="no"
    sudo apt install curl || curl_error="yes"
    error "curl" "$curl_error"
    echo "Info: Curl has finished installing"
fi


select_distro ()
{
    printf "\n"
    PS3='Select your OS: '
    options=("Ubuntu")
    select opt in "${options[@]}"
    do
        case $opt in
        "Ubuntu")
            cd ./OS/Ubuntu
            sudo ./Ubuntu.sh
            break
            ;;
        *)
            echo "Invalid"
            sleep 2s
            clear
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
    cd /home/$SUDO_USER/Git
    git clone git@github.com:thorpj/Linux-Scripts.git
}


Main ()
{
    git_clone
    select_distro
}
Main

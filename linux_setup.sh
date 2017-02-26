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

#printf "\n"
#if dpkg --get-selections | grep -q "^curl[[:space:]]*install$" >/dev/null; then
#    echo "Info: Curl is already installed"
#else
#    curl_error="no"
#    sudo apt install -y curl || curl_error="yes"
#    error "curl" "$curl_error"
#    echo "Info: Curl has finished installing"
#fi


select_distro ()
{
    printf "\n"
    PS3='Select your OS: '
    options=("Ubuntu")
    select opt in "${options[@]}"
    do
        case $opt in
        "Ubuntu")
            sudo /home/$SUDO_USER/Git/OS-Setup/os/ubuntu/ubuntu.sh
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


Main ()
{
    
    git config --global user.name "thorpj"
    git config --global user.email "thorpejoe4@gmail.com"
    git clone git@github.com:thorpj/Linux-Scripts.git /home/$SUDO_USER/Git/Linux-Scripts
    select_distro
}
Main

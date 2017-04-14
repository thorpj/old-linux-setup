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

cd /home/$SUDO_USER/git/os-setup/

select_distro ()
{
    printf "\n"
    PS3='Select your OS: '
    options=("Ubuntu")
    select opt in "${options[@]}"
    do
        case $opt in
        "Ubuntu")
            sudo /home/$SUDO_USER/git/os-setup/os/ubuntu/ubuntu.sh
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

main ()
{
    select_distro
}
main

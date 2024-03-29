#!/bin/bash

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

initial_setup ()
# Check if dependencies are met
{
    if dpkg-query -W -f'${Status}' "git" 2>/dev/null | grep -q "ok installed"; then
        :
    else
        echo "git is not installed. Installing..."
        sudo apt-get -q update
        sleep 1s
        sudo apt-get install -y -q git 
    fi
    sleep 1s
    if dpkg-query -W -f'${Status}' "curl" 2>/dev/null | grep -q "ok installed"; then
        :
    else
        echo "curl is not installed. Installing..."
        sudo apt-get -q update
        sleep 1s
        sudo apt-get install -y -q curl
    fi
}

main ()
{
    wget https://raw.githubusercontent.com/thorpj/linux-setup/master/variables.sh -P $HOME
    sleep 2s
    source $HOME/sens_variables.sh
    source $HOME/variables.sh
    initial_setup
    git config --global user.name "$github_user"
    git config --global user.email "$github_email"
    mkdir -p "$loc_git"
    mkdir -p "$loc_unigit"
    mkdir -p "$user_home/.temp"
    wget https://raw.githubusercontent.com/thorpj/linux-setup/master/send_ssh_key.sh -P $user_home
    sleep 2s
    source "$user_home/send_ssh_key.sh"
    git clone git@github.com:thorpj/linux-setup.git "$loc_git/linux-setup"
    if [ ! -f "$user_home/init.sh" ]; then
        rn "$user_home/init.sh"
    fi
    if [ ! -f "$user_home/send_ssh_key.sh" ]; then
        rm "$user_home/send_ssh_key.sh"
    fi
    if [ ! -f "$user_home/variables.sh" ]; then
        rm "$user_home/variables.sh" ]
    fi    
    if [ ! -f "$user_home/sens_variables.sh" ]; then
        rm "$user_home/sens_variables.sh"
    fi
    source "$loc_repo_os/${os_name}.sh"
}
main

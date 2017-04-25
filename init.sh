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

main ()
{
    wget https://raw.githubusercontent.com/thorpj/linux-setup/master/variables.sh -P $HOME
    source $HOME/sens_variables.sh
    source $HOME/variables.sh
    initial_setup
    git config --global user.name "$github_user"
    git config --global user.name "$github_email"
    sudo mkdir -p "$loc_git"
    sudo mkdir -p "$loc_unigit"
    sudo mkdir -p "$user_home/.temp"
    wget https://raw.githubusercontent.com/thorpj/linux-setup/master/send_ssh_key.sh -P $user_home
    sleep 2s
    bash "$user_home/send_ssh_key.sh"
    git clone git@github.com:thorpj/os-setup.git "$loc_git"
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

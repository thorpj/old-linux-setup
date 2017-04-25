#!/bin/bash
pwd
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
    source ./sens_variables.sh
    source ./variables.sh
    initial_setup
    git config --global user.name "$github_user"
    git config --global user.name "$github_email"
    sudo mkdir -p "$loc_git"
    sudo mkdir -p "$loc_unigit"
    sudo mkdir -p "$user_home/.temp"
    wget https://github.com/$github_user/linux-setup/blob/master/send_ssh_key.sh -P $user_home
    sleep 2s
    bash "$user_home/send_ssh_key.sh"
    git clone git@github.com:$github_user/os-setup.git "$loc_git"
    rm "$user_home/send_ssh_key.sh"
    rn "$user_home/init.sh"
    source "$loc_repo_os/${os_name}.sh"
}
main

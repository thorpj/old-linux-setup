#!/bin/bash
sys_username=$USER
if [ ! -f $HOME/.ssh/id_rsa.pub ]
    then
        ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
fi  
ssh_key=$(cat $HOME/.ssh/id_rsa.pub)
echo -e "\n"
echo $ssh_key
echo -e "\nAdd this ssh key to your Github account, if you haven't already."
read -p "Press enter once you have added the ssh key to your Github account. Press enter now if you already have. "
mkdir /home/$sys_username/Git
if [ ! -f /home/$sys_username/Git/OS-Setup/ ]
    then
        git clone git@github.com:thorpj/OS-Setup.git $HOME/Git/OS-Setup
fi
sudo /home/$sys_username/Git/OS-Setup/linux_setup.sh

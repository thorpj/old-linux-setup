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
read -p "Press enter once you have added the ssh key to your Github account: "
mkdir /home/$sys_username/Git
git clone git@github.com:thorpj/OS-Setup.git $HOME/Git/OS-Setup
sudo /home/$sys_username/Git/OS-Setup/linux-setup.sh

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
if [ ! -f $HOME/OS-Setup/ ]
    then
        git clone git@github.com:thorpj/OS-Setup.git $HOME/Git/OS-Setup
    else
        echo "WARNING: the directory $HOME/Git/OS-Setup already exists"
        echo "WARNING: the directory $HOME/Git/OS-Setup already exists" >> $HOME/Git/OS-Setup/os/ubuntu/log.txt
fi
if [ ! -f $HOME/.temp/ ]
    then
        mkdir $HOME/.temp
fi
if [ ! -f $HOME/Git/ ]
    then
        mkdir $HOME/Git
fi
sudo $HOME/Git/OS-Setup/linux_setup.sh

#!/bin/bash
sys_username=$USER
if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
        ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
fi  
echo -e "\n"
cat "$HOME/.ssh/id_rsa.pub"
printf "\nAdd this ssh key to your Github account, if you haven't already.\n"
read -p "Press enter to continue: "
if [ "$(dpkg-query -l "git")" != "" ]; then
    echo "git is not installed. Installing..."
    sudo apt update
    sudo apt install -y -q git 
fi
git config --global user.name "thorpj"
git config --global user.email "thorpejoe4@gmail.com"
if [ ! -f $HOME/git/ ]
    then
        mkdir $HOME/git
fi
if [ ! -f $HOME/git/OS-Setup/ ]
    then
        git clone git@github.com:thorpj/OS-Setup.git $HOME/git/OS-Setup
    else
        echo "WARNING: the directory $HOME/git/OS-Setup already exists"
        echo "WARNING: the directory $HOME/git/OS-Setup already exists" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
fi
if [ ! -f $HOME/git/Linux-Scripts/ ]
    then
        git clone git@github.com:thorpj/Linux-Scripts.git $HOME/git/Linux-Scripts
    else
        echo "WARNING: the directory $HOME/git/Linux-Scripts already exists"
        echo "WARNING: the directory $HOME/git/Linux-Scripts already exists" >> $HOME/git/OS-Setup/os/ubuntu/log.txt
fi
if [ ! -f $HOME/.temp/ ]
    then
        mkdir $HOME/.temp
fi

sudo $HOME/git/OS-Setup/linux_setup.sh

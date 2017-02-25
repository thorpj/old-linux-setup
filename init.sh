#!/bin/bash
sys_username=$USER
if [ ! -f $HOME/.ssh/id_rsa.pub ]
    then
        ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
fi  
ssh_key=$(cat $HOME/.ssh/id_rsa.pub)
read -p "Github Username: " username
read -p "Github Password: " password
read -p "Github Email: " email
curl -u "$username:$password" --data '{"title":"$email","key":"$ssh_key"}' https://api.github.com/user/keys
mkdir /home/$sys_username/Git
git clone git@github.com:thorpj/OS-Setup.git $HOME/Git/OS-Setup
sudo /home/$sys_username/Git/OS-Setup/linux-setup.sh
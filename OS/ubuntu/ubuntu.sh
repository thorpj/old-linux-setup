#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi
cd /home/$SUDO_USER/Git/OS-Setup/OS/Ubuntu
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


apt_install ()
{
#    apt_list=';' read -r id string <<< "$apt_list"

apt_list=$'\n' read -d '' -r -a lines < apt_package_list.txt
#
##    echo ${lines[@]}
#    for app in "${lines[@]}"
#    do
#        echo $app
##        IFS=' ' read -a app_info_arr <<< "$app"
##        echo ${app_info_arr[0]}
#    done
#echo ${lines[1]}
for app in "${lines[@]}"
do
echo $app
#sudo apt install $app
done
#
#array=( one two three )
#for i in "${array[@]}"
#do
#echo $i
#done



#    echo ${app_info_arr[@]}

#    for app in $apt_list
#    do
#        askyesno "Install?" true
#        if [ "$result" = true ]; then
#            apt install $app
#        fi
#    done
}


edit_bashrc ()
{
    cat bashrc_alises.txt >> /home/$SUDO_USER/.bashrc



}


configuration ()
{
    :
}


nonapt_install ()
{
    :
}


Main ()
{
    apt_install
}
Main


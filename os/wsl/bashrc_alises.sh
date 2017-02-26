#!/bin/bash
read -p "Home git directory path (ABSOLUTE): " home_git_win
read -p "Uni git directory path (ABSOLUTE):" uni_git_win

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

edit_bashrc ()
{
    cat 'aliases_list.txt' >> $HOME/.bashrc
    for file in $home_git_win/Linux-Scripts/*.sh
        do
            file=$(basename $file)
            name=${file%.sh}
            name=${name##*/}
            echo "alias $name='$HOME/git/Linux-Scripts/$file'" >> $HOME/.bashrc
    done
    echo "alias code='wrun \"/mnt/c/Program Files (x86)/Microsoft VS Code/Code.exe\"'" >> $HOME/.bashrc
    echo "alias cd_git_home='cd $home_git_win'" >> $HOME/.bashrc
    echo "alias cd_git_uni='cd $uni_git_win'" >> $HOME/.bashrc
}

main ()
{
    cd $HOME
    mkdir $HOME/git
    ln -s $home_git_win/* $HOME/git
    mkdir $HOME/uni_git
    ln -s $uni_git_win/* $HOME/uni_git
    edit_bashrc
    . $HOME/.bashrc
}
main

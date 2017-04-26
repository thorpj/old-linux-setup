#!/bin/bash
script_path="`dirname \"$0\"`"         
script_path="`( cd $script_path && pwd )`"
script_path=${script_path::-5}


nano "$script_path/variables.sh"
nano "$script_path/sens_variables.sh"
source variables.sh
source sens_variables.sh
nano "$loc_add_repos_list"
nano "$loc_repo/authorized_keys.txt"
nano "$loc_app_install_dir/app_list.txt"
nano "$loc_repo/repo_clone_list.txt"
nano "$loc_aliases_list"
nano "$loc_repo/vscode_desktop_settings.txt"
nano "$loc_repo/vscode_laptop_settings.txt"
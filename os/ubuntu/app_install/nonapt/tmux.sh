#!/bin/bash
set -e
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Exiting. Please run script as root"
    exit
fi

full_file_name="$0"
filename=$(basename "$full_file_name")
filename="${filename%.*}"
app="$filename"

sudo apt-get install -y tmux
touch $user_home/.tmux.conf
echo 'set-option -g prefix C-a' > $user_home/.tmux.conf
tmux source-file $user_home/.tmux.conf
git clone https://github.com/jimeh/tmuxifier.git $user_home/.tmuxifier
echo 'eval "$(tmuxifier init -)"' >> ~/.profile
echo 'export PATH="$user_home/.tmuxifier/bin:$PATH"' >> "$user_home/.bashrc"
echo "alias tmux_four='tmuxifier load-window tmux_four'" >> "$user_home/.bashrc"
echo "alias tmuxb_ver='tmuxifier load-window tmux_ver'" >> "$user_home/.bashrc"
echo "alias tmuxc_hor'tmuxifier load-window tmux_hor'" >> "$user_home/.bashrc"
mkdir -p $user_home/.tmuxifier/layouts
echo -e "new_window \"tmux_four\"\nsplit_v 50 0\nsplit_h 50 0\nsplit_h 50 1" > $user_home/.tmuxifier/layouts/tmux_four.window.sh
echo -e "new_window \"tmux_ver\"\nsplit_h 50 0" > $user_home/.tmuxifier/layouts/tmux_ver.window.sh
echo -e "new_window \"tmux_hor\"\nsplit_v 50 0" > $user_home/.tmuxifier/layouts/tmux_hor.window.sh
echo "$app has been installed"
echo "$app has been installed" >> "$loc_logfile"

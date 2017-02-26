#!/bin/bash
sudo apt update
sudo apt install -y tmux
touch $HOME/.tmux.conf
echo 'set-option -g prefix C-a' > $HOME/.tmux.conf
tmux source-file $HOME/.tmux.conf
cd $HOME
git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
echo 'eval "$(tmuxifier init -)"' >> ~/.profile
echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> $HOME/.bashrc
echo "alias tmuxa='tmuxifier load-window tmux_a'" >> $HOME/.bashrc
echo "alias tmuxb='tmuxifier load-window tmux_b'" >> $HOME/.bashrc
echo "alias tmuxc='tmuxifier load-window tmux_c'" >> $HOME/.bashrc
mkdir -p $HOME/.tmuxifier/layouts
echo -e "new_window \"tmux_a\"\nsplit_v 50 0\nsplit_h 50 0\nsplit_h 50 1" > $HOME/.tmuxifier/layouts/tmux_a.window.sh
echo -e "new_window \"tmux_b\"\nsplit_h 50 0" > $HOME/.tmuxifier/layouts/tmux_b.window.sh
echo -e "new_window \"tmux_c\"\nsplit_v 50 0" > $HOME/.tmuxifier/layouts/tmux_c.window.sh
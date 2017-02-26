#!/bin/bash
sudo apt install -y tmux
touch $HOME/.tmux.conf
echo 'set-option -g prefix C-a' > $HOME/.tmux.conf
tmux source-file $HOME/.tmux.conf
cd $HOME
git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
echo 'eval "$(tmuxifier init -)"' >> ~/.profile
echo 'export PATH="$HOME/.tmuxifier/bin:$PATH"' >> $HOME/.bashrc
echo "tmuxa='tmuxifier load-window tmux_a'" >> $HOME/.bashrc
echo "tmuxb='tmuxifier load-window tmux_b'" >> $HOME/.bashrc
mkdir -p $HOME/.tmuxifier/layouts
echo -e "new_window \"tmux_a\"\nsplit_v 50 0\nsplit_h 50 0\nsplit_h 50 1" > $HOME/.tmuxifier/layouts/tmux_a.window.sh
echo -e "new_window \"tmux_a\"\nsplit_h 50 0" > $HOME/.tmuxifier/layouts/tmux_b.window.sh
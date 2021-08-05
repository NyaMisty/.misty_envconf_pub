basedir=$(dirname $(realpath $0))
ln -s $basedir/.alacritty.yml ~/.alacritty.yml
ln -s $basedir/.vimrc ~/.vimrc
ln -s $basedir/.tmux.conf.local ~/.tmux.conf.local
ln -s $basedir/.zshrc ~/.zshrc

if [ -d "$basedir/_private" ]; then
    ln -s $basedir/_private/.ssh/config ~/.ssh/config
fi

if ! command -v realpath &> /dev/null; then
    realpath() {
      OURPWD=$PWD
      cd "$(dirname "$1")"
      LINK=$(readlink "$(basename "$1")")
      while [ "$LINK" ]; do
        cd "$(dirname "$LINK")"
        LINK=$(readlink "$(basename "$1")")
      done
      REALPATH="$PWD/$(basename "$1")"
      cd "$OURPWD"
      echo "$REALPATH"
    }
fi
basedir=$(dirname $(realpath $0))
ln -s $basedir/.alacritty.yml ~/.alacritty.yml
ln -s $basedir/.vimrc ~/.vimrc
ln -s $basedir/.tmux.conf.local ~/.tmux.conf.local
ln -s $basedir/.zshrc ~/.zshrc
ln -s $basedir/.gdbinit ~/.gdbinit

if [ -d "$basedir/_private" ]; then
    ln -s $basedir/_private/.ssh/config ~/.ssh/config
fi

if [ ! -f ~/.zshrc.local.template ]; then
  cp $basedir/.zshrc.local.template ~/.zshrc.local
fi

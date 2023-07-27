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

mkdir -p ~/.vim/autoload
ln -s $basedir/.vim/autoplug/plug.vim ~/.vim/autoload/plug.vim
ln -s $basedir/.vimrc ~/.vimrc

ln -s $basedir/.tmux.conf.local ~/.tmux.conf.local
ln -s $basedir/.zshrc ~/.zshrc
ln -s $basedir/.gdbinit ~/.gdbinit

ln -s $basedir/.ssh/config.envconf.d ~/.ssh/config.envconf.d
mkdir ~/.ssh/.s
if [ -d "$basedir/_private" ]; then
    ln -s $basedir/_private/.ssh/config ~/.ssh/config
else
    if ! grep -q 'config\.envconf\.d' ~/.ssh/config; then
        sed -i '1s|^|Include config.envconf.d/*.conf\n|' file
    fi
fi

if [ ! -f ~/.zshrc.local ]; then
  cp $basedir/.zshrc.local.template ~/.zshrc.local
fi

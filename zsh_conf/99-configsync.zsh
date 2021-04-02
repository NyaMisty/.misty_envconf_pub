#########################################################################
#
# config synchorization
#
#FAILED=""
#cp /mnt/d/Envs/LinuxEnvs/.vimrc ~/.vimrc >/dev/null 2>&1 || FAILED="$FAILED .vimrc"
#cp /mnt/d/Envs/LinuxEnvs/.alacritty.yml ~/.alacritty.yml >/dev/null 2>&1 || FAILED="$FAILED .alacritty.yml"
#cp /mnt/c/Users/Misty/.ssh/config ~/.ssh/config >/dev/null 2>&1 || FAILED="$FAILED .ssh/config"
#if [[ "$FAILED" != "" ]]; then
#    echo "Sync $FAILED failed"
#fi

() {
  cd "$ENVCONF_ROOT"
  setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
  git pull & disown
}
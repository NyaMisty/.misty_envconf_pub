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

do_merge() {
  (
    cd "$ENVCONF_ROOT"
    orihead=$(git rev-parse -q --verify HEAD)
    fetchhead=$(git rev-parse -q --verify FETCH_HEAD)
    if ! command -v setsid &> /dev/null; then
      (true | git fetch < /dev/null >/dev/null 2>&1) &
    else
      true | (setsid git fetch) >/dev/null 2>&1 &
    fi
    if [ -z "$fetchhead" ]; then
      echo "Failed to get fetch head, sync next time..."
      return
    fi
    if [ "$orihead" = "$fetchhead" ]; then
      return
    fi
    echo "EnvConf updated ($orihead->$fetchhead), trying to rebase..."
    
    oldsha=$(git rev-parse -q --verify refs/stash)
    git stash push -q
    newsha=$(git rev-parse -q --verify refs/stash)
    if [ "$oldsha" = "$newsha" ]; then
        made_stash_entry=false
    else
        made_stash_entry=true
    fi
    echo "   [*] rebasing..."
    #pwd
    git rebase $fetchhead
    #sh
    #return
    if [ "$made_stash_entry" = "true" ]; then
      if ! git stash pop -q >/dev/null 2>&1; then
        echo "   [!] failed to merge! reverting to original version..."
        git reset --hard $orihead >/dev/null 2>&1
        git stash pop -q >/dev/null 2>&1
      else
        echo "   [I] successfully merged!"
      fi
    fi
  )
}

() {
  setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
  do_merge &! # >/dev/null 2>&1 # & disown
}

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

TRAPUSR2 () {
    reset_prompt() {
        if command -v _p9k_reset_prompt >/dev/null; then
            _p9k_reset_prompt
        else
            zle reset-prompt
        fi
    }
    zle && reset_prompt
}
force_new_prompt () {
    #kill -USR2 $(exec sh -c 'echo "$PPID"')
    kill -USR2 $$
}

do_merge() {
  #(
    cd "$ENVCONF_ROOT"
    
    # Get and store commit number, so that we won't get lost
    orihead=$(git rev-parse -q --verify HEAD)
    fetchhead=$(git rev-parse -q --verify FETCH_HEAD)
    
    # Initiate fetch
    dofetch() {
        if ! command -v setsid &> /dev/null; then
          (true | git fetch < /dev/null >/dev/null 2>&1)
        else
          true | (setsid git fetch) >/dev/null 2>&1
        fi
    }
    if ! [ -z $ENVCONF_ASYNC_FETCH ]; then
        dofetch &
    else
        dofetch
    fi
    
    if [ -z "$fetchhead" ]; then
      echo "Failed to get fetch head, sync next time..."
      return
    fi

    # 0. Only perform merge when we are before origin
    #if [ "$orihead" = "$fetchhead" ]; then
    if [[ "$(git rev-list --count HEAD..FETCH_HEAD)" == "0" ]]; then
      return
    fi

    echo ''
    echo "EnvConf updated ($orihead->$fetchhead), trying to rebase..."
    
    # 1. stash to preserve local changes
    oldsha=$(git rev-parse -q --verify refs/stash)
    git stash push -q
    newsha=$(git rev-parse -q --verify refs/stash)
    if [ "$oldsha" = "$newsha" ]; then
        made_stash_entry=false
    else
        made_stash_entry=true
    fi
    
    # 2. do rebase (will always success because we stashed)
    echo "   [*] rebasing..."
    #pwd
    git rebase $fetchhead
    #sh
    #return

    # 3. restore stash if needed
    if [ "$made_stash_entry" = "true" ]; then
      # 4. auto-merge failed, revert everything
      if ! git stash pop -q >/dev/null 2>&1; then
        echo "   [!] failed to merge! reverting to original version..."
        git reset --hard $orihead >/dev/null 2>&1
        git stash pop -q >/dev/null 2>&1
      else
        echo "   [I] successfully merged!"
      fi
    fi
    force_new_prompt
  #)
}

() {
  setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
  do_merge &! # >/dev/null 2>&1 # & disown
}

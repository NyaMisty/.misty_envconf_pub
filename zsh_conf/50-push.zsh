# define $MISTYPUSH_CHAN in your .zshrc.local

function pushex() {
  body=$1
  desc=$2
  channel=$3
  if [ -z "$MISTYPUSH_SERVER" ]; then
    return
  fi
  curl "${MISTYPUSH_SERVER}/send" -d "text=$body" -d "desp=$desc" -d "chan=$channel"
}

function push() {
  body=$1
  channel=$2

  pushex $body "" $channel
}

zmodload zsh/datetime

prompt_preexec() {
  prompt_preexec_cmd="$1"
  #echo $prompt_preexec_cmd
  prompt_prexec_realtime=${EPOCHREALTIME}
}

prompt_precmd() {
  exitcode=$?
  if (( prompt_prexec_realtime )); then
    local -rF elapsed_realtime=$(( EPOCHREALTIME - prompt_prexec_realtime ))
    unset prompt_prexec_realtime

    if [[ $exitcode -eq 130 ]]; then
      return
    fi
    if (( elapsed_realtime < 40 )); then
      return
    fi
    if [[ "$prompt_preexec_cmd" =~ ^(htop|top|btop|watch|vim|tmux).* ]]; then
      return
    fi
    local -rF s=$(( elapsed_realtime%60 ))
    local -ri elapsed_s=${elapsed_realtime}
    local -ri m=$(( (elapsed_s/60)%60 ))
    local -ri h=$(( elapsed_s/3600 ))

    if (( h > 0 )); then
      printf -v prompt_elapsed_time '%ih%im' ${h} ${m}
    elif (( m > 0 )); then
      printf -v prompt_elapsed_time '%im%is' ${m} ${s}
    elif (( s >= 10 )); then
      printf -v prompt_elapsed_time '%.2fs' ${s} # 12.34s
    elif (( s >= 1 )); then
      printf -v prompt_elapsed_time '%.3fs' ${s} # 1.234s
    else
      printf -v prompt_elapsed_time '%ims' $(( s*1000 ))
    fi

    (pushex "cmd finish in ${prompt_elapsed_time} on $(uname -n)" "cmd: ${prompt_preexec_cmd}" "$MISTYPUSH_CHAN" &)
  else
    # Clear previous result when hitting ENTER with no command to execute
    unset prompt_elapsed_time
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd prompt_precmd

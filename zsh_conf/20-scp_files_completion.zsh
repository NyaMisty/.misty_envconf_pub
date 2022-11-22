# Modified based on https://github.com/zsh-users/zsh/blob/master/Completion/Unix/Type/_remote_files
# Use ControlMaster to minimize actual SSH connections
_remote_files() {

# There should be coloring based on all the different ls -F classifiers.
local expl rempat remfiles remdispf remdispd args cmd suf ret=1
local -a args cmd_args
local glob host dir dirprefix

if zstyle -T ":completion:${curcontext}:files" remote-access; then
  zstyle ":completion:$curcontext:" cache-policy _remote_caching_policy
  zstyle ":completion:$curcontext:" use-cache true

  # Parse options to _remote_files. Stops at the first "--".
  zparseopts -D -E -a args / g:=glob h:=host W:=dir
  (( $#host)) && shift host || host="${IPREFIX%:}"

  args=( ${argv[1,(i)--]} )
  shift ${#args}
  [[ $args[-1] = -- ]] && args[-1]=()
  # Command to run on the remote system.
  cmd="$1"
  shift

  # Handle arguments to ssh.
  #if [[ $cmd == ssh ]]; then
  if false; then
    zparseopts -D -E -a cmd_args p: 1 2 4 6 F:
    cmd_args=( -o BatchMode=yes "$cmd_args[@]" -a -x )
  else
    cmd_args=( "$@" )
  fi

  if (( $#dir )); then
    dirprefix=${dir}/
  fi

  if [[ -z $QIPREFIX ]]
    then rempat="${dirprefix}${PREFIX%%[^./][^/]#}\*"
    else rempat="${dirprefix}${(q)PREFIX%%[^./][^/]#}\*"
  fi

  if ! _retrieve_cache "_remote_files_${host}_${rempat}" || [ -z "$remfiles" ] || _cache_invalid "_remote_files_${host}_${rempat}"; then

      if [ -d ~/.ssh/_zsh_completion ]; then
        echo "zsh _remote_files: use master conn" >> /tmp/ssh_wrap_log
        cmd_args=(-o "ControlMaster=no" -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -o BatchMode=yes -a -x)
      fi
      spawned=0
      succ=0
      for i in {0..10}; do
        # remote filenames
        remfiles=(${(M)${(f)"$(
          _call_program files $cmd $cmd_args $host \
            command ls -d1FL -- "$rempat" 2>/dev/null
        )"}%%[^/]#(|/)})
        if [ -d ~/.ssh/_zsh_completion ]; then
          break
        fi
        
        if ! [ -z $? ]; then
          if ! ssh -o "ControlMaster=no" -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -O check "$host" | grep "Master running" >/dev/null 2>&1; then
            if [[ "$spawned" == "0" ]]; then
                (ssh -o "ControlMaster=yes" -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -N -M "$host" &; disown)
                spawned=1
            fi
            sleep 0.5 
          else
            echo  "zsh _remote_files: master conn success" >> /tmp/ssh_wrap_log
            break
          fi
        fi
      done
      
      _store_cache "_remote_files_${host}_${rempat}" remfiles
  
  else
      echo "Got cache: $remfiles" >> /tmp/ssh_wrap_log
  fi

  compset -P '*/'
  compset -S '/*' || (( ${args[(I)-/]} )) || suf='remote file'

  # display strings for remote files and directories
  remdispf=(${remfiles:#*/})
  remdispd=(${(M)remfiles:#*/})

  if (( $#glob )); then
    match=( '(|[*=|])' )
    glob[2]="${glob[2]/(#b)\(((|^)[p=\*]))(#e)/}"
    glob[2]+="${${match[1]/p/\|}/\*/\*}"
    remdispf=( ${(M)remdispf:#${~glob[2]}} )
  fi

  local -a autoremove
  [[ -o autoremoveslash ]] && autoremove=(-r "/ \t\n\-")

  _tags remote-files
  while _tags; do
    while _next_label remote-files expl ${suf:-remote directory}; do
      [[ -n $suf ]] &&
          compadd "$args[@]" "$expl[@]" -d remdispf -- ${(q)remdispf%[*=|]} && ret=0
      compadd ${suf:+-S/} $autoremove "$args[@]" "$expl[@]" -d remdispd \
	-- ${(q)remdispd%/} && ret=0
    done
    (( ret )) || return 0
  done
  return ret
else
    _message -e remote-files 'remote file'
fi
}

#_remote_files() {
#  echo "zsh _remote_files: $IPREFIX $*" >> /tmp/ssh_wrap_log
#  #unfunction _remote_files
#  #autoload +X _remote_files
#  if [ -d ~/.ssh/_zsh_completion ]; then
#    echo "zsh _remote_files: use master conn" >> /tmp/ssh_wrap_log
#    host="${IPREFIX%:}"
#    succ=1
#    if ! ssh -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -O check "$host" >/dev/null 2>&1; then
#      succ=0
#      ssh -N -M "$host" &
#      for i in {0..6}; do
#        if ! ps -p $PID > /dev/null; then
#          break
#        fi
#        if ssh -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -O check "$host" >/dev/null 2>&1; then
#          succ=1
#          break
#        fi
#        sleep 0.5
#      done
#    fi
#    if [[ "$succ" == "1" ]]; then
#      echo  "zsh _remote_files: master conn success" >> /tmp/ssh_wrap_log
#      
#      _remote_files_ori -- ssh -o "ControlPath=~/.ssh/_zsh_remote_files:%h:%p:%r" -o BatchMode=yes -a -x
#      return
#    fi
#  fi
#  _remote_file_ori $*
#}

(( $+functions[_remote_caching_policy] )) ||
_remote_caching_policy() {
    oldp=( "$1"(Nms+10) )
    (( $#oldp ))
}


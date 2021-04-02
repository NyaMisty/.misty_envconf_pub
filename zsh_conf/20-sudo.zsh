#########################################################################
#
# sudo/systemd related configs

alias osudo='/usr/bin/sudo '
alias sudo='sudo -E '
alias su='sudo -E zsh'

#function systemctl {
    #C=''
    #for i in "$@"; do 
    #    i="${i//\\/\\\\}"
    #    C="$C \"${i//\"/\\\"}\""
    #done
    #echo $C
#    SYSSHELL=1 /bin/bash -c "systemctl $(printf ' %q' "$@")"
#}

alias sysshell='SYSSHELL=1 /bin/bash'


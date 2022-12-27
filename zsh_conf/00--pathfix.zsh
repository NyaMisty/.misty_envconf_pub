#!/usr/bin/zsh
# Clean dup path first, 
# then clean /mnt path entries before oh-my-zsh init, 
# finally restore them afterwards

# In ZSH, $path and $PATH are tied array

typeset -U path

export ORIPATH=$PATH

# Clean Windows PATH
#IFS=: read -r -a patharr <<<"$PATH"
#for index in "${!patharr[@]}" ; do 
#    [[ ${patharr[$index]} =~ ^/mnt/.* ]] && unset -v 'patharr[$index]'
#done
#patharr=("${patharr[@]}")

#patharr=("${(@s/:/)PATH}")

path=(${path:#/mnt*})

#export PATH=$( printf '%s:' "${patharr[@]}" )

export WSL_REQUIRED_PATH="/mnt/c/Program Files/Git/cmd"
export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:$WSL_REQUIRED_PATH:$PATH
typeset -U path

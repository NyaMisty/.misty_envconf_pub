# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

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

export ENVCONF_BLACKLIST=()
export ENVCONF_ROOT=$(dirname $(realpath "${(%):-%x}"))

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
#cp -RT /mnt/d/Envs/LinuxEnvs/zsh_conf/. ~/.zshconf >/dev/null 2>&1 || FAILED="$FAILED zshconf"

for file in $ENVCONF_ROOT/zsh_conf/*.zsh; do
    is_black=0
    #echo $file
    for blackentry in $ENVCONF_BLACKLIST; do
        #if [[ "$file" =~ "$blackentry" ]]; then
        if echo "$file" | grep -Eq "$blackentry"; then
            is_black=1
        fi
    done
    if [ "$is_black" = "0" ]; then
        #echo "Loaded $file"
        if command -v zgenom >/dev/null 2>&1 && [[ ! $file = *.dyn.zsh ]]; then
            if [ -z $ZGENOM_SAVED ]; then
                # echo "NotCached $file"
                # echo zgenom load "$ENVCONF_ROOT" "root/${file#$ENVCONF_ROOT/}"
                zgenom load "NyaMisty/zgenom_envconf" "root/${file#$ENVCONF_ROOT/}"
            else
                # echo "Cached $file"
            fi
        else
            # echo "Dyn: $file"
            source "$file"
        fi
    fi
done


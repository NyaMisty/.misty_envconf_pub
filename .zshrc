export ENVCONF_BLACKLIST=()
export ENVCONF_ROOT=$(dirname $(realpath "${(%):-%x}"))

if [ -f ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
#cp -RT /mnt/d/Envs/LinuxEnvs/zsh_conf/. ~/.zshconf >/dev/null 2>&1 || FAILED="$FAILED zshconf"

for file in $ENVCONF_ROOT/zsh_conf/*; do
    is_black=0
    #echo $file
    for blackentry in $ENVCONF_BLACKLIST; do
        if [[ "$file" =~ "$blackentry" ]]; then
            is_black=1
        fi
    done
    if [ "$is_black" = "0" ]; then
        #echo "Loaded $file"
        source "$file"
    fi
done
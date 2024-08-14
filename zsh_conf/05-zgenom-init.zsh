export ZGENOM=${ZGENOM:-~/.zgenom}

[[ -d $ZGENOM ]] || git clone https://github.com/jandamm/zgenom $ZGENOM

# directly link envconf into zgenom, so that we can load ourself
ZGENOM_ENVCONF="$ZGENOM/sources/NyaMisty/zgenom_envconf/___"
[[ -d "$ZGENOM_ENVCONF/root" ]] || ( mkdir -p "$ZGENOM_ENVCONF"; ln -s "$ENVCONF_ROOT" "$ZGENOM_ENVCONF/root" ) #touch "$ZGENOM_ENVCONF/.zgenom-keep"; 

# detects new file and changed file
export ZGEN_RESET_ON_CHANGE=(${ENVCONF_ROOT}/zsh_conf/*)
export ZGEN_COMPINIT_FLAGS="-u "

source $ZGENOM/zgenom.zsh

zgenom autoupdate  # every 7 days

if ! zgenom saved; then
    ZGENOM_SAVED=""
    zgenom compdef
else
    ZGENOM_SAVED="1"
fi

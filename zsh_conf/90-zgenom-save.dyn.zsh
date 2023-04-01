export ZSH_DISABLE_COMPFIX=true
if [ -z $ZGENOM_SAVED ]; then

    # Finalize
    zgenom clean
    alias compinit="compinit -u"
    zgenom save
    zgenom compile $ZGENOM
fi

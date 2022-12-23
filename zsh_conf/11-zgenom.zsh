export ZGENOM=${ZGENOM:-~/.zgenom}

[[ -d $ZGENOM ]] || git clone https://github.com/jandamm/zgenom $ZGENOM

source $ZGENOM/zgenom.zsh

zgenom autoupdate  # every 7 days

# Stub compdef for zgenom
compdef() {}

if ! zgenom saved; then
    # OMZ configs are performed in 10-oh-my-zsh-conf
    # OMZ Core
    zgenom ohmyzsh lib/termsupport.zsh
    zgenom ohmyzsh lib/key-bindings.zsh
    
    zgenom ohmyzsh lib/completion.zsh
    zgenom ohmyzsh lib/compfix.zsh

    zgenom ohmyzsh lib/theme-and-appearance.zsh # LSCOLORS/setopts
    zgenom ohmyzsh lib/spectrum.zsh # A script to make using 256 colors in zsh less painful

    zgenom ohmyzsh lib/functions.zsh # omz helpers (urldecode / upgrade_oh_my_zsh)
    #zgenom ohmyzsh lib/clipboard.zsh


    # OMZ prompts
    zgenom ohmyzsh lib/prompt_info_functions.zsh # stub git prompt
    #zgenom ohmyzsh lib/git.zsh    # git prompt & git alias (replaced by p10k)


    # OMZ misc tweaks
    zgenom ohmyzsh lib/grep.zsh    # grep auto exclude git/svn dirs
    zgenom ohmyzsh lib/history.zsh # hist format & size
    zgenom ohmyzsh lib/misc.zsh
    #compdef() {}; zgenom ohmyzsh lib/directories.zsh; unset -f compdef; # use --completion will cause ls alias not working
    zgenom ohmyzsh lib/directories.zsh # LS alias (ll, la, l), need compdef stub

    # Load OMZ Theme
    if [[ $ZSH_THEME == "powerlevel10k/powerlevel10k" ]]; then
        zgenom load romkatv/powerlevel10k powerlevel10k
    else
        zgenom ohmyzsh lib/git.zsh    # git prompt (replaced by p10k)
        zgenom ohmyzsh themes/$ZSH_THEME
    fi

    # Load OMZ plugins
    #zgenom ohmyzsh plugins/sudo
    #zgenom ohmyzsh plugins/extract
    #zgenom ohmyzsh plugins/pip
    zgenom ohmyzsh plugins/git # git alias (gca gpf)

    #zgenom ohmyzsh --completion plugins/rust
    #zgenom ohmyzsh --completion plugins/docker-compose

    # Other plugins

    #zgenom load Aloxaf/fzf-tab  # TODO: move `compinit` to the top of it?
    zgenom load zdharma-continuum/fast-syntax-highlighting
    #zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-history-substring-search
    zgenom load marlonrichert/zsh-edit  # TODO: remove it but keep the subword widget
    zgenom load QuarticCat/zsh-autopair

    # Finalize
    zgenom clean
    zgenom save
    zgenom compile $ZGENOM
fi


# nvm
export NVM_DIR="$HOME/.nvm"

export NVM_HAS_INIT=""

nvm() {
    if [[ "$NVM_HAS_INIT" = "" ]]; then
        unset nvm
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
        #[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        # place this after nvm initialization!
        autoload -U add-zsh-hook
        load-nvmrc() {
          if [[ ! -v NVM_DIR ]]; then
            
            echo "Loading nvm..."
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
          fi
          local node_version="$(nvm version)"
          local nvmrc_path="$(nvm_find_nvmrc)"

          if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

            if [ "$nvmrc_node_version" = "N/A" ]; then
              nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
              nvm use
            fi
          elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
          fi
        }
        #add-zsh-hook chpwd load-nvmrc
        () {
          setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
          #load-nvmrc & disown
        }
    fi
    nvm "$@"
}

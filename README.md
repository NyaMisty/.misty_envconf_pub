# .misty_envconf

Here's my own ZSH shell environment, it has several special features:

- has no fancy console key bindings
- fully modularized
- suitable to be used on other Unix-like platforms like iOS/Android

## Functions

- Flexible config
    - auto config synchonrize based on Git: silently update config on each shell startup
    - can disable modules using local config file

- Fluent proxy wrapper:
    - sets all sorts of proxy variables
    - support temporarily changing proxy by setting `PROXY_STR` variable and then run `proxy` command
    - support temporarily disabling proxy by using `unproxy` command
    - aliases proxychains4
    - proxies apt
    - proxies git ssh

- Better sudo:
    - sudo by default using `sudo -E`
    - su being replaced by `sudo -E zsh`, which allow us to use ZSH environment in root mode temporarily
    - original sudo (without -E) can be found at `osudo`

- Various helpers:
    - nvm lazy load (nvm is extremely slow to load, so enable the whole nvm environment it only if nvm are called)
    - oh-my-zsh wrapper
    - pyenv wrapper
    - "forget last command history" helper

## Installation

1. Clone this repo
2. Execute ./install.sh, and copy .zshrc.local.template to ~/.zshrc.local
3. In .zshrc.local, override the environment to blacklist some module using `ENVCONF_BLACKLIST` variable, or control the behaviour of modules

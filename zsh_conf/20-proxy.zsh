#########################################################################
#
# Global smart proxy configurations
# By default it proxies everything
#
#

# pre-setup the git: git config --global core.sshcommand 'sh -c '"'"'eval "$GITSSHFUNC"; gitsshfun "$@"'"'"' _ '

alias proxychains='proxychains4 '

# When connect to ipv6 without ipv6, we still need proxychains...
alias _p='ALL_PROXY= all_proxy= HTTP_PROXY= http_proxy= HTTPS_PROXY= https_proxy= proxychains4 '
alias _pq='_p -q '

if command -v cproxy &> /dev/null; then
  if [[ "$TPROXY_PORT" = "" ]]; then
    export TPROXY_PORT=60080
  fi
  function _proxyCommand {
    ALL_PROXY= all_proxy= HTTP_PROXY= http_proxy= HTTPS_PROXY= https_proxy= cproxy --port $TPROXY_PORT --mode tproxy -- "$@"
  }
  #alias p='_proxyCommand '
  alias p='ALL_PROXY= all_proxy= HTTP_PROXY= http_proxy= HTTPS_PROXY= https_proxy= cproxy --port '$TPROXY_PORT' --mode tproxy -- '
  alias pq=p
else
  function _proxyCommand {
    ALL_PROXY= all_proxy= HTTP_PROXY= http_proxy= HTTPS_PROXY= https_proxy= proxychains4 "$@"
  }
  #alias p='_proxyCommand '
  #alias pq='_proxyCommand -q'
  #alias p='ALL_PROXY= all_proxy= HTTP_PROXY= http_proxy= HTTPS_PROXY= https_proxy= proxychains4 '
  #alias pq='p -q' 
  alias p=_p
  alias pq=_pq
fi

#alias p='ALL_PROXY= all_proxy= proxychains4 '
#alias pq='ALL_PROXY= all_proxy= proxychains4 -q'
alias pin='ALL_PROXY= all_proxy= proxychains4 -f /etc/proxychains4_internal.conf '
alias pdbg='ALL_PROXY= all_proxy= proxychains4 -f /etc/proxychains4_debug.conf '

alias aptp='pq \apt '
alias sshp='pq \ssh '
# For IPV6
alias sshp6='_pq \ssh'
alias npmp='pq \npm '
alias moshp='pq \mosh'

compdef sshp=ssh
compdef npmp=npm
compdef aptp=apt
compdef moshp=mosh

setopt complete_aliases
compdef _precommand p
compdef _precommand pq
compdef _precommand pin
compdef _precommand pdbg
compdef _precommand proxychains
compdef _precommand proxychains4

# specify $PROXY_STR in .zshrc.local to override proxy string
# export PROXY_STR="${PROXY_STR}"

proxy () {
  if [ ! -z ${PROXY_STR+x} ]; then
    export ALL_PROXY="$PROXY_STR"
  else
    orihost="parent-host"
    host=""
    if command -v getent &> /dev/null; then
      host=$(getent ahosts $orihost | head -n 1 | awk '{ print $1 }' | head -n 1)
    fi
    if [[ "$host" = "" ]]; then
      host=$orihost
    fi
    export ALL_PROXY="http://$host:7890"
  fi

  if [ -z $ALL_PROXY ]; then
    return
  fi

  export all_proxy=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export http_proxy=$ALL_PROXY
  export https_proxy=$ALL_PROXY

  #alias apt=aptp
  alias ssh=sshp
  alias npm=npmp
  alias mosh=moshp
  
  alias gitssh=sshp
  
  update_gitsshfun
  #curl https://ip.gs &
}

unproxy () {
  unset ALL_PROXY
  unset all_proxy
  unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
  alias gitssh=ssh
  curl https://ip.gs &
  update_gitsshfun
}

update_gitsshfun() {
    eval 'gitsshfun() { gitssh "$@" }'

    export GITSSHFUNC=$(which gitsshfun)
}

proxy

#########################################################################
#
# pyenv configs
export PYENV_ROOT="${PYENV_ROOT:-/opt/pyenv}"
if [ -d "$PYENV_ROOT" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv 1>/dev/null 2>&1; then
  #eval "$(pyenv init --path)"
  if ! command -v smartcache >/dev/null; then
      eval "$(pyenv init - --no-rehash)" # init - (init completion & path) is superset of init --path (path only)
      eval "$(pyenv virtualenv-init -)"
  else
      smartcache eval pyenv init - --no-rehash
      smartcache eval pyenv virtualenv-init -
  fi
      
  pyenv rehash &!
 
  # pyenv does not use user site 
  export PYTHONNOUSERSITE="true"

  export PYENV_PY3_VERSION=${PYENV_PY3_VERSION:-3.10.4}
  function pipx() {
      curprefix=$(pyenv prefix $PYENV_PY3_VERSION) PIPX_DEFAULT_PYTHON=$curprefix/bin/python PIPX_HOME=$curprefix/pipx PIPX_BIN_DIR=$curprefix/bin command pipx "$@"
      #alias pipx='curprefix=$(pyenv prefix $PYENV_PY3_VERSION) PIPX_DEFAULT_PYTHON=$curprefix/bin/python PIPX_HOME=$curprefix/pipx PIPX_BIN_DIR=$curprefix/bin \pipx'
  }
fi


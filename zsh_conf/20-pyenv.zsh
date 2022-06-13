#########################################################################
#
# pyenv configs
export PYENV_ROOT="${PYENV_ROOT:-/opt/pyenv}"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export PIPENV_VENV_IN_PROJECT=1
export PYTHONNOUSERSITE="true"

#export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

export PYENV_PY3_VERSION=${PYENV_PY3_VERSION:-3.10.4}

function pipx() {
    curprefix=$(pyenv prefix $PYENV_PY3_VERSION) PIPX_DEFAULT_PYTHON=$curprefix/bin/python PIPX_HOME=$curprefix/pipx PIPX_BIN_DIR=$curprefix/bin command pipx "$@"
}
#alias pipx='curprefix=$(pyenv prefix $PYENV_PY3_VERSION) PIPX_DEFAULT_PYTHON=$curprefix/bin/python PIPX_HOME=$curprefix/pipx PIPX_BIN_DIR=$curprefix/bin \pipx'

# Old handcrafted vpip (obsolete)
oldvpip() {
function _vpip {
    PYVER=$1
    VENV_NAME=$2
    if ! pyenv prefix $2 2>&1 >/dev/null; then
        pyenv virtualenv $1 $2
        pyenv global $( pyenv global | xargs echo ) $2
    else
        echo "Venv $2 exists, continuing!"
    fi
    PYENV_VERSION=$2 pyenv exec pip3 ${@: 3}
}

function vpip3 {
    envname=$1
    _vpip $PYENV_PY3_VERSION $envname ${@: 2}
}

function vpip3inst {
    pkgname=$1
    _vpip $PYENV_PY3_VERSION $pkgname install $pkgname
}
}

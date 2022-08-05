export PIPENV_VENV_IN_PROJECT=1


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

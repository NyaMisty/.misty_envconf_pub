export GVM_DIR="$HOME/.gvm"
[[ -s "$GVM_DIR/scripts/gvm" ]] && source "$GVM_DIR/scripts/gvm"

alias gvmdocker="dockertest -v $""HOME/.gvm:/root/.gvm -v /mnt:/mnt -w $""PWD nyamisty/dev-go zsh -c '. ~/.zshrc; git config --global --add safe.directory "'"'"*"'"'"; gvm use '$""gvm_go_name'; set -x; $""@ ' '' "

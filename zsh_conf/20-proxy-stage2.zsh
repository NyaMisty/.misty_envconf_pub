if command -v compdef > /dev/null; then
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
fi

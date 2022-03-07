#########################################################################
#
# docker helper commands
#
function docker_update_images {
    echo "docker images | grep -v ^REPO | sed 's/ \+/:/g' | cut -d: -f1,2 | xargs -L1 docker pull"
    docker images | grep -v ^REPO | sed 's/ \+/:/g' | cut -d: -f1,2 | xargs -L1 docker pull
    echo 'docker image prune'
    docker image prune
}

function last_docker {
    docker ps -q -l
}

function dockertest {
    sudo touch ~/.newenv_zsh_history ~/.newenv_zsh_history.new
    eval 'docker run --rm \
        -v ~/.newenv_zsh_history:/root/.zsh_history \
        -v ${PWD}:/workdir -w /workdir \
        --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -e DISPLAY -v "${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" -v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
        -it \
        "$@" \
        '
}

function run_simpledev {
    docker_param=$1
    command_line=$2
    sudo touch ~/.newenv_zsh_history ~/.newenv_zsh_history.new
    eval 'docker run --rm \
        -v ~/.newenv_zsh_history:/root/.zsh_history \
        -v ${PWD}:/workdir -w /workdir \
        --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro' \
        $docker_param \
        '-it nyamisty/dev' \
        $command_line
}

#alias newenv='touch ~/.newenv_zsh_history ~/.newenv_zsh_history.new; docker run --rm -v ${PWD}:/workdir -v ~/.newenv_zsh_history:/root/.zsh_history -w /workdir -it nyamisty/dev'
alias newenv='dockertest nyamisty/dev'
function newsystemd {
    #container=$(run_simpledev "-d $1" systemd)
    container=$(dockertest -d $1 nyamisty/dev systemd)
    docker exec -it "$container" zsh
    docker rm -fv $container
}

#########################################################################
#
# work configs & snippets
#
alias work="cd /mnt/d/Workspaces"
alias temp="cd /mnt/e/Temp"
function docker_update_images {
    echo "docker images | grep -v ^REPO | sed 's/ \+/:/g' | cut -d: -f1,2 | xargs -L1 docker pull"
    docker images | grep -v ^REPO | sed 's/ \+/:/g' | cut -d: -f1,2 | xargs -L1 docker pull
    echo 'docker image prune'
    docker image prune
}

function last_docker {
    docker ps -q -l
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
alias newenv='run_simpledev'
function newsystemd {
    container=$(run_simpledev "-d $1" systemd)
    docker exec -it "$container" zsh
    docker rm -fv $container
}

alias vimzshrc="vim /mnt/d/Envs/LinuxEnvs/.zshrc; exec $SHELL"
alias vimrc="vim /mnt/d/Envs/LinuxEnvs/"

# dockcross
export PATH=$PATH:/opt/dockcross

# git gettext.sh error due to pyenv
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

export THEOS=/opt/theos

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
alias vimzshrc="vim /mnt/d/Envs/LinuxEnvs/.zshrc; exec $SHELL"
alias vimrc="vim /mnt/d/Envs/LinuxEnvs/"

# dockcross
export PATH=$PATH:/opt/dockcross

# git gettext.sh error due to pyenv
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

export THEOS=/opt/theos
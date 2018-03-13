# bash profile

# bash settings
set -o vi


dp0="$( dirname "${BASH_SOURCE[0]}" )"
root="$( dirname $dp0 )"
modules="$dp0/modules"

if [ ! -d $modules ]; then
    git submodule update
fi

### Auto adjust Azure CLI configuration dir ###################################

_azure_cli_hook() {
    # When enter a folder check if there is a .azure-config folder set that 
    # folder as AZURE_CONFIG_DIR
    
    timestamp=`date "+%H:%M"`

    if [[ -n `command -v az` ]] && [[ -d .azure-config ]]; then
        export AZURE_CONFIG_DIR=$(cd .azure-config; pwd)
        GIT_PROMPT_END=' [\[\033[0;32m\]az*\[\033[0;0m\]] \n$timestamp $ '
    else
        unset AZURE_CONFIG_DIR
        GIT_PROMPT_END=' \n$timestamp $ '
    fi
}

PROMPT_COMMAND="_azure_cli_hook;$PROMPT_COMMAND"


### Git prompt  ###############################################################

bash_git_prompt_path="$modules/bash-git-prompt/gitprompt.sh"
if [ -f $bash_git_prompt_path ]; then
    GIT_PROMPT_THEME=Chmike
    GIT_PROMPT_ONLY_IN_REPO=0
    source $bash_git_prompt_path
else
    echo "Missing Bash Git Prompt. Try restore the submodules."
fi


### Pyenv #####################################################################

if [ -d ~/.pyenv/bin ]; then
    export PATH="/home/troy/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

### Shortcuts #################################################################

home () {
    cd $root
    if [ ! -z "$1" ]; then
        cd $1
    fi
}

go-profile () {
  cd $dp0
}

which fortune > /dev/null 2>&1 && echo && fortune && echo

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# GIT complete
source $dp0/git-completion.bash

# turn off bell
set bell-style visual

home

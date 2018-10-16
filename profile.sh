# bash profile

# bash settings
set -o vi


dp0="$(dirname $(readlink ${BASH_SOURCE[0]}))"
root="$( dirname $dp0 )"
modules="$dp0/modules"


if [ ! -d $modules ]; then
    git submodule update
fi

bash_git_prompt_path="$modules/bash-git-prompt/gitprompt.sh"
if [ -f $bash_git_prompt_path ]; then
    GIT_PROMPT_THEME=Chmike
    GIT_PROMPT_ONLY_IN_REPO=0
    source $bash_git_prompt_path
else
    echo "Missing Bash Git Prompt. Try restore the submodules."
fi


### Shortcuts #################################################################

home () {
    cd $root
    if [ ! -z "$1" ]; then
        cd $1
    fi
}

which fortune > /dev/null 2>&1 && echo && fortune && echo


# GIT complete
source $dp0/git-completion.bash

# turn off bell
set bell-style visual

home

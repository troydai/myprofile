# bash profile

dp0="$( dirname "${BASH_SOURCE[0]}" )"
root="$( dirname $dp0 )"
modules="$dp0/modules"

if [ ! -d $modules ]; then
    git submodule update
fi

bash_git_prompt_path="$modules/bash-git-prompt/gitprompt.sh"
if [ -f $bash_git_prompt_path ]; then
    source $bash_git_prompt_path
else
    echo "Missing Bash Git Prompt. Try restore the submodules."
fi

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

# Go Programming Language
export PATH=$PATH:$(go env GOPATH)/bin

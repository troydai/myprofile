# bash profile

# This is the bash profile of Troy Dai (contact@troydai.com)

# VIM mode
set -o vi

# Find the paths
dp0=`cd $(dirname $(readlink ${BASH_SOURCE[0]})); cd ..; pwd`
modules="$dp0/modules"

# Show the modules missing, which happens when the repository was not cloned recursively.
if [ ! -d $modules ]; then
    git submodule update
fi

# Set up the git prompt
bash_git_prompt_path="$modules/bash-git-prompt/gitprompt.sh"
if [ -f $bash_git_prompt_path ]; then
    GIT_PROMPT_THEME=Chmike
    GIT_PROMPT_ONLY_IN_REPO=0
    source $bash_git_prompt_path
else
    echo "Missing Bash Git Prompt. Try restore the submodules."
fi

# Print fortune
which fortune > /dev/null 2>&1 && echo && fortune && echo

# GIT complete
if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
else
    echo "Missing bash git completion. Run brew install git bash-completion to install it."
fi

# Turn off bell
set bell-style visual

# Additional Paths
export PATH="/usr/local/sbin:$PATH"

# Aliases
alias gococo='cd ~/gocode/src/code.uber.internal/infra/coconut'
alias gopf="cd $dp0"

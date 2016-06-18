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

code () {
  VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}

home () {
    cd $root
    if [ ! -z "$1" ]; then
        cd $1
    fi
}

go-profile () {
    cd $dp0
}

nuke-packages () {
    $dp0/modules/k.toolkit/clean-packages.py
}

nuke-runtimes () {
    $dp0/modules/k.toolkit/clean-runtimes.py
}

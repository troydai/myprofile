# bash profile

echo "Welcome, Troy!"

dp0="$( dirname "${BASH_SOURCE[0]}" )"
root="$( dirname $dp0 )"
modules="$dp0/modules"

bash_git_prompt_path="$modules/bash-git-prompt/gitprompt.sh"
if [ -f $bash_git_prompt_path ]; then
    source $bash_git_prompt_path
else
    echo "Missing Bash Git Prompt. Try restore the submodules."
fi

local_dnvm_path="$modules/aspnet-home/dnvm.sh"
if [ -f $local_dnvm_path ]; then
    source $local_dnvm_path
else
    echo "Missing DNVM. Try restore the submodules."
fi

export DNX_FEED="https://www.myget.org/F/aspnetvnext/api/v2"

code () {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}

home () {
    cd $root
}

go-profile () {
    cd $dp0
}

# vim
vim_path="/usr/local/Cellar/vim/7.4.712/bin"
if [ -d $vim_path ]; then
    PATH="$vim_path;${PATH}"
else
    echo "Missing vim bin. Looked at $vim_path."
fi


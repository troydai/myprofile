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

local_dnvm_path="$modules/aspnet-home/dnvm.sh"
if [ -f $local_dnvm_path ]; then
    source $local_dnvm_path
else
    echo "Missing DNVM. Try restore the submodules."
fi

export DNX_UNSTABLE_FEED="https://www.myget.org/F/aspnetcidev/api/v2"

code () {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}

home () {
    cd $root
}

go-profile () {
    cd $dp0
}

dnx-clean-packages () {
    $dp0/modules/k.toolkit/clean-packages.py
}

dnx-clean-runtimes () {
    $dp0/modules/k.toolkit/clean-runtimes.py
}

# vim
vim_path="/usr/local/Cellar/vim/7.4.979/bin"
if [ -d $vim_path ]; then
    PATH=$vim_path:${PATH}
else
    if [ ! -f /usr/bin/vim ]; then
        echo "Missing vim bin. Looked at $vim_path. and /usr/bin/vim"
    fi
fi

# mock GAC
# set the DOTNET_REFERENCE_ASSEMBLIES_PATH to mono reference assemblies folder
# https://github.com/dotnet/cli/issues/531
if [ -z "$DOTNET_REFERENCE_ASSEMBLIES_PATH" ]; then
  if [ $(uname) == Darwin ] && [ -d "/Library/Frameworks/Mono.framework/Versions/Current/lib/mono/xbuild-frameworks" ]; then
    export DOTNET_REFERENCE_ASSEMBLIES_PATH="/Library/Frameworks/Mono.framework/Versions/Current/lib/mono/xbuild-frameworks"
  elif [ -d "/usr/local/lib/mono/xbuild-frameworks" ]; then
    export DOTNET_REFERENCE_ASSEMBLIES_PATH="/usr/local/lib/mono/xbuild-frameworks"
  elif [ -d "/usr/lib/mono/xbuild-frameworks" ]; then
    export DOTNET_REFERENCE_ASSEMBLIES_PATH="/usr/lib/mono/xbuild-frameworks"
  fi
fi


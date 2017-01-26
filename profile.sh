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

go-dotnet () {
  cd $( dirname `type -p dotnet` )
}

go-nuget() {
  cd $HOME/.local/share/NuGet/
}

nuke-packages () {
  $dp0/modules/k.toolkit/clean-packages.py
}

nuke-cli () {
  type dotnet > /dev/null 2>&1 || { echo ".NET CLI is not found"; return; }

  dotnet_folder=$( dirname `type -p dotnet`)
  echo "Removing .NET CLI at $dotnet_folder"

  rm -rf $dotnet_folder
}

get-cli () {
  branch="1.0.0-preview2"

  echo "Getting latest .NET CLI from branch $branch"
  install_script_url="https://raw.githubusercontent.com/dotnet/cli/rel/$branch/scripts/obtain/dotnet-install.sh"
  curl -L $install_script_url | bash
  dotnet --info || { echo "Failed to install .NET CLI"; }
}

list-sdks () {
  type dotnet > /dev/null 2>&1 || { echo ".NET CLI is not found"; return; }

  dotnet_folder=$( dirname `type -p dotnet`)

  ls $dotnet_folder/sdk
}

list-shared-runtimes () {
  type dotnet > /dev/null 2>&1 || { echo ".NET CLI is not found"; return; }

  dotnet_folder=$( dirname `type -p dotnet`)

  ls $dotnet_folder/shared/Microsoft.NETCore.App/
}

clear-docker-none-images () {
  for image_id in `docker images | grep "<none>" | tr -s ' ' | cut -d ' ' -f3`
  do
    docker rmi $image_id $@
  done
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

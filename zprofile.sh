# zsh profile

dp0=`cd $(dirname $0); pwd`
root=`cd $(dirname $dp0); pwd`

### Environment Variables #####################################################
export PATH="$PATH:$dp0/modules/powerline/scripts"

### GO Programming Language ###################################################

[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin

if command -v go >/dev/null 2>&1; then
    export PATH="$(go env GOPATH)/bin:$PATH"
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

### RBENV #####################################################################

if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi


# Travis
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

home

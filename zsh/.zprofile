export MY_PROFILE_ROOT=`cd $(dirname $(readlink -n ${(%):-%N})); cd ..; pwd`
code=`cd $MY_PROFILE_ROOT; cd ..; pwd`

## Environment Variables #####################################################
export PATH="$PATH:$MY_PROFILE_ROOT/modules/powerline/scripts"

export MY_PROFILE_ROOT=`cd $(dirname $(readlink -n ${(%):-%N})); cd ..; pwd`

#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING HISTOGRAPH IMPORT %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"


export MY_MODULE="import"
export MY_REPO="https://github.com/histograph"

# install histograph-import
install_nodecode

# add import user to the group that can read pipo exports
sudo usermod -a -G www-data ${MYUSER}
#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING HISTOGRAPH DATA %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

# install histograph-data
install_data

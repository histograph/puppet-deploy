#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH DATA %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

# install histograph-data
install_data

#sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml ${DATA_REPOSITORIES}"
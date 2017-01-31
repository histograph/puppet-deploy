#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH IMPORT %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"


export MY_MODULE="import"
export MY_REPO="https://github.com/histograph"

# install histograph-import
install_nodecode

sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml ${DATA_REPOSITORIES} ${EL_DATA_REPOSITORIES}"

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

if [ "$(read_params  histograph.data.doImport) " == "true " ]
then
  THE_REPOS="${DATA_REP_ONDISK} ${DATA_REP_TODOWNLOAD} ${EL_DATA_REP}"
  echo "Import repos ${THE_REPOS}"
  sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml ${THE_REPOS}"
fi

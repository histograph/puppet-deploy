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

if [ "$(read_params  histograph.data.doDownload) " == "true " ]
then
  echo "Download repos ${DATA_REP_TODOWNLOAD}"

  cd ${SRC_HOME}/data
  sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml ${DATA_REP_TODOWNLOAD}"
fi

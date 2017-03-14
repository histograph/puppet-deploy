#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% DOWNLOADING AND IMPORTING HISTOGRAPH DATA %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

cd ${SRC_HOME}
if [ -f screenlog.0 ]
then
  rm screenlog.0
fi

screen -L -S DOWNLOADIMPORTDATA -d -m time $(dirname $0)/download-import-data "${1}"

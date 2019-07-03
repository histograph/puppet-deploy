#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% DOWNLOADING AND IMPORTING HISTOGRAPH DATA %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

cd ${SRC_HOME}
if [ -f screenlog.0 ]
then
  rm screenlog.0
fi

screen -L -S DOWNLOADIMPORTDATA -d -m time $(dirname $0)/../utils/download-import-data "${1}"

# curl -XPUT 'localhost:9200/_all/_settings?pretty' -H 'Content-Type: application/json' -d'{"index.indexing.slowlog.threshold.index.info": "25ms"}'
# curl -XPUT 'localhost:9200/_all/_settings?pretty' -H 'Content-Type: application/json' -d'{"index.indexing.slowlog.threshold.index.warn": "100ms"}'
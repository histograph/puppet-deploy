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

  if [ "$(echo $DATA_REP_TODOWNLOAD | grep bag)" != "" ]
  then
    cd ${SRC_HOME}

    wget http://data.nlextract.nl/bag/postgis/bag-laatst.backup -O bag-laatst.backup.new

    if [ ! -f bag-laatst.backup -o bag-laatst.backup.new -nt bag-laatst.backup ]
    then
      mv bag-laatst.backup.new bag-laatst.backup
      su postgres -c "psql" < $(dirname $0)/bag.sql
      su postgres -c "pg_restore --jobs 4 --dbname=bag --exit-on-error bag-laatst.backup"
    fi
  fi

  cd ${SRC_HOME}/data
  sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml ${DATA_REP_TODOWNLOAD}"
fi

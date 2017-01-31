#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING E&L PIPO %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

export MY_MODULE="pipo"
export MY_REPO="https://github.com/erfgoed-en-locatie"
export MY_WEBDIR="$(read_params nginx.vhosts.importeren_histograph.www_root)"

MY_WEBDIR=${MY_WEBDIR%/web}

# install e&L pipo
install_phpcode

cd ${SRC_HOME}/${MY_DEST}

mysql --user="$(read_params mysql.users.histograph.name)" \
      --password="$(read_params mysql.users.histograph.password)" \
      "$(read_params mysql.databases.histograph.name)" < ./sql/pipo.sql



find ${MY_WEBDIR} -mindepth 1 -type d -exec rm -rf {} \;

find ${MY_WEBDIR} -type f -exec rm -rf {} \;

cp -r app images web vendor src ${MY_WEBDIR}

chown -R www-data:www-data ${MY_WEBDIR}

# chmod -R ug+wxrX ${MY_WEBDIR}/app/storage/cache ${MY_WEBDIR}/app/storage/log ${MY_WEBDIR}/app/storage/uploads
chmod -R ug+wxrX ${MY_WEBDIR}

service nginx restart

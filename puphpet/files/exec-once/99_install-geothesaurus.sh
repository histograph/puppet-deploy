#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING E&L GEOTHESAURUS %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

export MY_MODULE="geothesaurus"
export MY_REPO="https://github.com/erfgoed-en-locatie"

# install e&L pipo
install_source

# sudo su $MYUSER -c "HISTOGRAPH_CONFIG=\"${SRC_HOME}/config.yaml\" npm run production"
# cp -r config.json index.html css dist js images fonts /var/www/${MY_MODULE}
# chown -R www-data:www-data /var/www/${MY_MODULE}

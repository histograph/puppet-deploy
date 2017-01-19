#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH VIEWER %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

export MY_MODULE="viewer"

# install histograph-viewer
install_code

sudo su $MYUSER -c "HISTOGRAPH_CONFIG=\"${SRC_HOME}/config.yaml\" npm run production"
cp -r config.json index.html css dist js images fonts /var/www/${MY_MODULE}
chown -R www-data:www-data /var/www/${MY_MODULE}

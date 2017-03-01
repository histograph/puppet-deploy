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
export MY_REPO="https://github.com/histograph"
export MY_WEBDIR="$(read_params nginx.vhosts.viewer_histograph.www_root)"

# install histograph-viewer
install_nodecode
clean_webdir

sudo su $MYUSER -c "npm run prebuild && HISTOGRAPH_CONFIG=\"${SRC_HOME}/config.yaml\" npm run production"

cp -r config.json index.html css dist js images fonts ${MY_WEBDIR}

set_CLIENT_webdirperm

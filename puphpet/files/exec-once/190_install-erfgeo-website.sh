#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%%% INSTALLING ERFGEO WEBSITE %%%%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

export MY_MODULE="erfgoed-en-locatie.github.io"
export MY_REPO="https://github.com/histograph"
export MY_WEBDIR="$(read_params nginx.vhosts.erfgeo_website.www_root)"

# install erfgeo website
install_source
clean_webdir

cp -r _site/* ${MY_WEBDIR}

set_CLIENT_webdirperm

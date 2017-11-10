#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%%% INSTALLING ERFGEO WEBSITE %%%%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

export MY_MODULE="erfgoed-en-locatie.github.io"
export MY_REPO="https://github.com/histograph"
export MY_WEBDIR="$(read_params nginx vhosts.erfgeo_website.www_root)"

# install erfgeo website
install_source
clean_webdir

cd ${SRC_HOME}/${MY_PLACE}
# echo "current directory $PWD"
cp -r _site/* ${MY_WEBDIR}

set_PHP_webdirperm

# NOOOOO: all dir needs to be owned by www-user PHP daemon
# Need to enable php execution
# MY_WEBDIR=${MY_WEBDIR}/thesaurus
# set_PHP_webdirperm 


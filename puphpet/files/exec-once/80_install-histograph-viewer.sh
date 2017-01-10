#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH VIEWER %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

set -x
source $(dirname $0)/set-vars.sh

MY_MODULE="viewer"

# install histograph-viewer

cd ${SRC_HOME}

if [ ! -d ${SRC_HOME}/${MY_MODULE} ]
then
  # clone master branch
  sudo su $MYUSER -c "git clone https://github.com/histograph/${MY_MODULE}.git"
  if [ ! "${MY_BRANCH} " == " " ]
  then
    sudo su $MYUSER -c "git checkout ${MY_BRANCH}"
  elif [ ! "${MY_TAG} " == " " ]
  then
    sudo su $MYUSER -c "git checkout tags/${MY_TAG}"
  fi
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/${MY_MODULE}/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/${MY_MODULE}

sudo su $MYUSER -c "${NPM_INSTALL}"

sudo su $MYUSER -c "HISTOGRAPH_CONFIG=\"${SRC_HOME}/config.yaml\" npm run production"
cp -r config.json index.html css dist js images /var/www/${MY_MODULE}
chown -R www-data:www-data /var/www/${MY_MODULE}

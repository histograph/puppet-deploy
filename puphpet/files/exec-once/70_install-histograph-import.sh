#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH IMPORT %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

source $(dirname $0)/set-vars.sh

# install histograph-core
set -x
cd ${SRC_HOME}

if [ ! -d ${SRC_HOME}/import ]
then
  # clone master branch
  sudo su $MYUSER -c "git clone https://github.com/histograph/import.git"
  if [ ! "${MY_BRANCH} " == " " ]
  then
    sudo su $MYUSER -c "git checkout ${MY_BRANCH}"
  elif [ ! "${MY_TAG} " == " " ]
  then
    sudo su $MYUSER -c "git checkout tags/${MY_TAG}"
  fi
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/import/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/import
sudo su $MYUSER -c "rm -rf node_modules/"
sudo su $MYUSER -c "${NPM_INSTALL}"

sudo su $MYUSER -c "node index.js --config ${SRC_HOME}/config.yaml geonames"

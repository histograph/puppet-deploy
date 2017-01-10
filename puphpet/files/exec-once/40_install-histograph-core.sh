#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH CORE %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

source $(dirname $0)/set-vars.sh

# install histograph-core

cd ${SRC_HOME}

if [ ! -d ${SRC_HOME}/core ]
then
  # clone master branch
  sudo su $MYUSER -c "git clone https://github.com/histograph/core"
  if [ ! "${MY_BRANCH} " == " " ]
  then
    sudo su $MYUSER -c "git checkout ${MY_BRANCH}"
  elif [ ! "${MY_TAG} " == " " ]
  then
    sudo su $MYUSER -c "git checkout tags/${MY_TAG}"
  fi
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/core/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/core
sudo su $MYUSER -c "rm -rf node_modules/"
sudo su $MYUSER -c "${NPM_INSTALL}"

# create init.d scripts
#install_service core

# install service and start it
install_service core

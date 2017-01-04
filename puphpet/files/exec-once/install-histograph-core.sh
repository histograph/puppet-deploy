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
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/core/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/core
sudo su $MYUSER -c "npm install"

# create init.d scripts
#install_service core

# start it now ?
#service histograph-core start
#service histograph-core status

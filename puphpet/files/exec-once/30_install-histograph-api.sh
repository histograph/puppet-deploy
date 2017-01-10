#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH API %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

source $(dirname $0)/set-vars.sh

# install histograph

cd ${SRC_HOME}

if [ ! -d ${SRC_HOME}/api ]
then
  # clone master branch
  sudo su $MYUSER -c "git clone https://github.com/histograph/api"
  if [ ! "${MY_BRANCH} " == " " ]
  then
    sudo su $MYUSER -c "git checkout ${MY_BRANCH}"
  elif [ ! "${MY_TAG} " == " " ]
  then
    sudo su $MYUSER -c "git checkout tags/${MY_TAG}"
  fi
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/api/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/api
sudo su $MYUSER -c "rm -rf node_modules/"
sudo su $MYUSER -c "${NPM_INSTALL}"


# install service and start it
install_service api

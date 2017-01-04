#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH API %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

source $(dirname $0)/set-vars.sh

# mount filesystem
if [ ! -d ${UPLOADS_DIR} ]
then
  mkdir ${UPLOADS_DIR}
fi

chown -R ${MYUSER}:${MYUSER} ${UPLOADS_DIR}
chmod ug+rwX ${UPLOADS_DIR}


# dirs for log and PID files
if [ ! -d /var/log/${MYUSER} ]
then
  mkdir -p /var/log/${MYUSER}
fi

if [ ! -d /var/run/${MYUSER} ]
then
  mkdir -p /var/run/${MYUSER}
fi

chown ${MYUSER}:${MYUSER} /var/log/${MYUSER}/ /var/run/${MYUSER}/

# install histograph

cd ${SRC_HOME}

if [ ! -d ${SRC_HOME}/api ]
then
  # clone master branch
  sudo su $MYUSER -c "git clone https://github.com/histograph/api"
else
  sudo su $MYUSER -c "git -C ${SRC_HOME}/api/ pull"
fi
# install node dependencies

cd ${SRC_HOME}/api
sudo su $MYUSER -c "npm install"


# install service and start it
install_service api

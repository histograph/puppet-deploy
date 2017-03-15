#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING HISTOGRAPH DIRS %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

# set -x
source $(dirname $0)/set-vars "${1}"

service postgresql stop

# apt-get update

if [ ! -d ${SRC_HOME} ]
then
  mkdir ${SRC_HOME}
fi

if [ "$(find ${SRC_HOME} \! -user ${MYUSER}) " != " " ]
then
  chown -R ${MYUSER}:${MYUSER} ${SRC_HOME} 2>/dev/null
fi

# create upload directory
if [ ! -d ${UPLOADS_DIR} ]
then
  mkdir ${UPLOADS_DIR}
  chown -R ${MYUSER}:${MYUSER} ${UPLOADS_DIR}
  chmod ug+rwX ${UPLOADS_DIR}
fi


# dirs for log and PID files
if [ ! -d ${LOG_DIR} ]
then
  mkdir -p ${LOG_DIR}
  chown ${MYUSER}:${MYUSER} ${LOG_DIR}
fi

if [ ! -d ${RUN_DIR} ]
then
  mkdir -p ${RUN_DIR}
  chown ${MYUSER}:${MYUSER} ${RUN_DIR}
fi

# set +x

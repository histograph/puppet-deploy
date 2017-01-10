#!/usr/bin/env bash
# run as root
# echo
# echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
# echo "----%%%%% SET VARIABLES %%%%%----"
# echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
# echo

export SRC_HOME="/home/histograph/src"
export DEV_HOME="/home/vagrant/src"
export MYUSER=histograph
export UPLOADS_DIR="/uploads"
export NEO_PLUGIN_DIR="/var/lib/neo4j/plugins"
export BASEPORT=3000
export BASEURL="http://localhost:${BASEPORT}"
export MY_TAG=""
export MY_BRANCH="puppetdeploy"

export RUN_DIR="/var/run/histograph"
export LOG_DIR="/var/log/histograph"

export NPM_INSTALL="npm install 1>/dev/null"
# export MY_TAG="v0.5.1"

install_service()
{

SERVICE=${1}
FOREVER_CONFIG="${SRC_HOME}/${SERVICE}.forever.json"

cat > ${FOREVER_CONFIG} << FOREVER
{
    "uid": "${SERVICE}",
    "append": true,
    "watch": false,
    "script": "index.js",
    "sourceDir": "${SRC_HOME}/${SERVICE}",
    "pidFile": "${RUN_DIR}/${SERVICE}.pid",
    "logFile": "${LOG_DIR}/${SERVICE}.log",
    "args": ["--config", "${SRC_HOME}/config.yaml"]
}
FOREVER

chown ${MYUSER}:${MYUSER} ${FOREVER_CONFIG}

cat > /etc/init.d/histograph-${SERVICE} << INITD
#!/bin/bash
### BEGIN INIT INFO
# If you wish the Daemon to be lauched at boot / stopped at shutdown :
#
#    On Debian-based distributions:
#      INSTALL : update-rc.d scriptname defaults
#      (UNINSTALL : update-rc.d -f  scriptname remove)
#
#    On RedHat-based distributions (CentOS, OpenSUSE...):
#      INSTALL : chkconfig --level 35 scriptname on
#      (UNINSTALL : chkconfig --level 35 scriptname off)
#
# chkconfig:         2345 90 60
# Provides:          ${SRC_HOME}/${SERVICE}/index.js
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Histograph ${SERVICE}
# Description:       histograph-${SERVICE}
### END INIT INFO

FOREVER_CONFIG="${FOREVER_CONFIG}"
FOREVER_UID=${SERVICE}
FOREVER_USER=${MYUSER}

case "\$1" in
    start)
        su "\$FOREVER_USER" -c "NODE_ENV=production forever start --uid \$FOREVER_UID \$FOREVER_CONFIG"
        RETVAL=\$?
        ;;
    stop)
        su "\$FOREVER_USER" -c "NODE_ENV=production forever stop \$FOREVER_UID"
        RETVAL=\$?
        ;;
    restart)
        su "\$FOREVER_USER" -c "NODE_ENV=production forever restart \$FOREVER_UID"
        RETVAL=\$?
        ;;
    status)
        su "\$FOREVER_USER" -c "forever list"
        RETVAL=\$?
        ;;
    *)
        echo "Usage:  {start|stop|status|restart}"
        exit 1
        ;;
esac
exit \$RETVAL
INITD

# start on startup
chmod +x /etc/init.d/histograph-${SERVICE}
update-rc.d histograph-${SERVICE} defaults

service histograph-${SERVICE} start
service histograph-${SERVICE} status

}


if [ -d ${DEV_HOME} ]
then
  # we are in developer mode, change variables
  SRC_HOME="${DEV_HOME}"
  MYUSER=vagrant
elif [ ! -d ${SRC_HOME} ]
then
  mkdir ${SRC_HOME}
fi

chown -R ${MYUSER}:${MYUSER} ${SRC_HOME} 2>/dev/null

# create upload directory
if [ ! -d ${UPLOADS_DIR} ]
then
  mkdir ${UPLOADS_DIR}
fi

chown -R ${MYUSER}:${MYUSER} ${UPLOADS_DIR}
chmod ug+rwX ${UPLOADS_DIR}

# dirs for log and PID files
if [ ! -d ${LOG_DIR} ]
then
  mkdir -p ${LOG_DIR}
fi

if [ ! -d ${RUN_DIR} ]
then
  mkdir -p ${RUN_DIR}
fi

chown ${MYUSER}:${MYUSER} ${LOG_DIR} ${RUN_DIR}

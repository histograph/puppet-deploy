#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING LOGROTATE %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x

LOGROTATE_HOME="/etc/logrotate.d"


# cat > ${LOGROTATE_HOME}/elasticsearch << ELASTICSEARCH
# /var/log/elasticsearch/${ES_INSTNAME}/*.log {
#   copytruncate
#   daily
#   rotate 7
#   compress
#   missingok
#   notifempty
#   size 10M
# }
# ELASTICSEARCH


cat > ${LOGROTATE_HOME}/histograph << HISTOGRAPH
/var/log/histograph/*.log {
  su histograph histograph
  copytruncate
  daily
  rotate 7
  compress
  missingok
  notifempty
  size 50M
}
HISTOGRAPH

cat > ${LOGROTATE_HOME}/neo4j << NEO4J
/var/log/neo4j/*.log {
	su neo4j neo4j
	copytruncate
	rotate 7
	daily
	compress
	missingok
	notifempty
  size 10M
}
NEO4J

cat > ${LOGROTATE_HOME}/standaardiseren << STANDARDISEEREN
/var/www/importeren/app/storage/log/*.log {
	su www-user www-data 
	copytruncate
	rotate 7
	daily
	compress
	missingok
	notifempty
  size 10M
}
STANDARDISEEREN

cat > ${LOGROTATE_HOME}/importeren << IMPORTEREN
/var/www/importeren/app/storage/log/*.log {
	su www-user www-data
	copytruncate
	rotate 7
	daily
	compress
	missingok
	notifempty
  size 10M
}
IMPORTEREN

sudo chown root:root /etc/logrotate.d/*

sudo chmod 644 /etc/logrotate.d/*

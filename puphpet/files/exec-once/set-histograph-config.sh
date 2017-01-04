#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH CONFIG %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

source $(dirname $0)/set-vars.sh

if [ ! -f ${SRC_HOME}/config.yaml ]
then

  # histograph config file
cat > ${SRC_HOME}/config.yaml << HISTOGRAPH
api:
  bindHost: 0.0.0.0
  bindPort: 3000
  baseUrl: https://api.erfgeo.nl/
  dataDir: /tmp/uploads
  admin:
    name: histograph
    password: histograph

core:
  batchSize: 1500
  batchTimeout: 1500

import:
  dirs:
    - ${SRC_HOME}/data/
    - ${SRC_HOME}/extra-data/

redis:
  host: 127.0.0.1
  port: 6379
  queue: histograph
  maxQueueSize: 50000

elasticsearch:
  host: 127.0.0.1
  port: 9200

neo4j:
  host: 127.0.0.1
  ports: 7474
HISTOGRAPH
fi

chown ${MYUSER}:${MYUSER} ${SRC_HOME}/config.yaml 2>/dev/null

#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING HISTOGRAPH CONFIG %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"


# if [ ! -f ${SRC_HOME}/config.yaml ]
# then

  # histograph config file
cat > ${SRC_HOME}/config.yaml << HISTOGRAPH
api:
  bindHost: 0.0.0.0
  bindPort: ${APIBASEPORT}
  baseUrl: ${APIBASEURL}
  dataDir: ${UPLOADS_DIR}
  admin:
    name: ${APIUSER}
    password: ${APIPASSWORD}

core:
  batchSize: ${COREBATCHSIZE}
  batchTimeout: ${COREBATCHTIMEOUT}

import:
  dirs:
    - ${SRC_HOME}/data/
    - ${SRC_HOME}/e_l_data/

redis:
  host: 127.0.0.1
  port: 6379
  queue: histograph
  maxQueueSize: ${REDISMAXQUEUESIZE}

elasticsearch:
  host: 127.0.0.1
  port: 9200
  pagesize: ${PAGE_SIZE}
  number_of_shards: ${SHARD_NR}
  number_of_replicas: ${REPLICA_NR}
  requestTimeoutMs: ${ES_TIMEOUT}

neo4j:
  host: 127.0.0.1
  port: 7474
HISTOGRAPH

# fi

chown ${MYUSER}:${MYUSER} ${SRC_HOME}/config.yaml 2>/dev/null
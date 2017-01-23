#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "----%%%%% INSTALLING NEO4J PLUGIN %%%%%----"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/set-vars "${1}"

export MY_MODULE="neo4j-plugin"
export MY_REPO="https://github.com/histograph"

# install maven
apt-get install -y maven >/dev/null

install_code

# build and install plugin
cd ${SRC_HOME}/neo4j-plugin/
sudo su $MYUSER -c "mvn package >/dev/null"
cp ${SRC_HOME}/neo4j-plugin/target/histograph-plugin-*.jar ${NEO_PLUGIN_DIR}
chown neo4j:adm ${NEO_PLUGIN_DIR}/histograph-plugin-*.jar

# restart
service neo4j restart

# function to test if http is up
http_okay () {
  res=`curl -fsI $1 | grep HTTP/1.1 | awk {'print $2'}`
  if [ "$res" = "200" ];
  then
    echo testing $1, status is: OK;
    return 0;
  else
    echo testing $1, status is: not okay;
    return 1;
  fi
}

# wait until neo4j is up
until http_okay localhost:7474;
do
  sleep 3s;
done;

# setup schema
neo4j-shell -c "CREATE CONSTRAINT ON (n:_) ASSERT n.id IS UNIQUE;"

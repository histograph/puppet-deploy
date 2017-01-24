if ! sudo apt-key list | grep 'Neo4j' >/dev/null
then
  wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
fi

if [ ! -f /etc/apt/sources.list.d/neo4j.list ]
then
  echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list
fi

sudo apt-get update
# sudo apt-get -y upgrade

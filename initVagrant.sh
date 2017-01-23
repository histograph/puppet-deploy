#!/usr/bin/env bash

V_VERS="1.8.7"
# PLUGIN_LIST="landrush vagrant-aws vagrant-managed-servers vagrant-share vagrant-triggers vagrant-bindfs"
PLUGIN_LIST="landrush vagrant-bindfs"

if ! vagrant --version | grep "${V_VERS}" >/dev/null
then
  echo "WARNING: environment tested with ${V_VERS}, you have $(vagrant --version)"
fi

MY_BOX=$(grep 'box: ' puphpet/config.yaml | grep ubuntu | sed 's/.*box: \(.*\)/\1/g')

if ! vagrant box list | grep ${MY_BOX} > /dev/null
then
  echo "Adding box"
  vagrant box add ${MY_BOX} --provider virtualbox
fi

PLUGINS="$(vagrant plugin list)"


for i in ${PLUGIN_LIST}
do
  if ! echo ${PLUGINS} | grep "${i}" >/dev/null
  then
    vagrant plugin install "${i}"
  fi
done

if [ ! -f ./puphpet/files/dot/ssh/id_rsa ]
then
  echo "Key not installed, get it from the conf dir on OwnCloud"
  exit 1
fi

# for i in $(puppet module --modulepath ./modules list | sed -E 's/├──( [a-zA-Z0-9\-]+) \(.*\)/\1/g' | grep "^ " | tr '\n' ' '); do puppet module --module-path ./modules upgrade ${i}; done

echo "Configuration seems to be OK"

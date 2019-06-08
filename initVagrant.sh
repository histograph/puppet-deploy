#!/usr/bin/env bash

if [ "$(echo $0)" != "-bash" ]
then
	echo "Run the command with source!!!"
	exit 1
fi

MY_CMD=$1

if [ -z "${MY_CMD}" ]
then
	echo "You must specify either LOCAL, AWS or HETZNER, exiting"
	return 1
fi

V_VERS="2.2.4"

if ! vagrant --version | grep "${V_VERS}" >/dev/null
then
  echo "WARNING: environment tested with ${V_VERS}, you have $(vagrant --version)"
fi

if [ "${MY_CMD}" = "AWS" ]
then
  echo "Setting Vagrant for AWS"
  if ! vagrant plugin list | grep vagrant-aws
  then
    vagrant plugin install vagrant-aws
  fi

  if ! vagrant box list | grep dummy | grep aws
  then
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
  fi

  export VAGRANT_TARGET=aws && echo VAGRANT_TARGET=$VAGRANT_TARGET!!
  export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep -i AWS_ACCESS_KEY_ID | tr -d ' ' | cut -d'=' -f2) && echo AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID!!
  export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep -i AWS_SECRET_ACCESS_KEY | tr -d ' ' | cut -d'=' -f2) && echo AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY!!
elif [ "${MY_CMD}" = "LOCAL" ]
then
  echo "Resetting Vagrant to local environment and preparing repositories"
  unset VAGRANT_TARGET
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY

  export VAGRANT_TARGET=local && echo VAGRANT_TARGET=$VAGRANT_TARGET!!

  MY_BOX=$(grep 'box: ' puphpet/config.yaml | sed 's/.*box: \(.*\)/\1/g')
  MY_BOXVERSION=$(grep 'box_version: ' puphpet/config.yaml | sed "s/.*box_version: '\(.*\)'/\1/g")

  if ! vagrant box list | grep ${MY_BOX} | grep ${MY_BOXVERSION} > /dev/null
  then
    echo "Adding box ${MY_BOX} version ${MY_BOXVERSION}"
    vagrant box add --provider virtualbox --box-version ${MY_BOXVERSION} ${MY_BOX}
  fi

  if [ ! -f ./puphpet/files/dot/ssh/id_rsa ]
  then
    echo "Key not installed, get it from the conf dir on OwnCloud"
    exit 1
  fi

	if [ ! -d ../histograph ]
	then
    echo "Creating histograph directory for local development"
		mkdir -P ../histograph
	fi
elif [ "${MY_CMD}" = "HETZNER" ]
then
	echo "Setting Vagrant for HETZNER"
  export VAGRANT_TARGET=hetzner && echo VAGRANT_TARGET=$VAGRANT_TARGET!!
fi

PLUGINS="$(vagrant plugin list)"
#PLUGIN_LIST="landrush vagrant-aws vagrant-managed-servers vagrant-share vagrant-triggers vagrant-bindfs"
PLUGIN_LIST="vagrant-managed-servers"


for i in ${PLUGIN_LIST}
do
  if ! echo ${PLUGINS} | grep "${i}" >/dev/null
  then
    vagrant plugin install "${i}"
  fi
done

# for i in $(puppet module --modulepath ./modules list | sed -E 's/├──( [a-zA-Z0-9\-]+) \(.*\)/\1/g' | grep "^ " | tr '\n' ' '); do puppet module --module-path ./modules upgrade ${i}; done

echo "Configuration seems to be OK"

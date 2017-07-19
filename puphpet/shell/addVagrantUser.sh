#!/bin/sh
# Script to be run to create a vagrant user suitable for Puppet deployment

if [ "$#" -ne "5" ]
then
  echo "$0 requires 5 parameters: ssh_username hostname port startuser keyfile"
  exit 1
fi

MY_USER=${1}
MY_HOST=${2}
MY_PORT=${3}
MY_STARTUSER=${4}
MY_KEYFILE=${5}


MY_KEY="$(cat ${MY_KEYFILE}.pub)"

# echo ${MY_KEY}

#exit 1

ssh -i ${MY_KEYFILE} -p ${MY_PORT} ${MY_STARTUSER}@${MY_HOST} <<EndOfScript

  if id -u ${MY_USER} >/dev/null 2>&1
  then
	   echo "User ${MY_USER} already exists"
	   exit 0;
  fi

  if id -u ubuntu >/dev/null 2>&1
  then
	   sudo deluser --remove-all-files ubuntu
     sudo delgroup ubuntu
  fi

  sudo adduser  --disabled-password --gecos "${MY_USER} for Puppet","","","" ${MY_USER}

  sudo su ${MY_USER} -c "cd && mkdir .ssh && chmod 700 .ssh && cd .ssh && echo ${MY_KEY} > authorized_keys && chmod 600 authorized_keys"

  echo "Changing sudoers"

  echo "${MY_USER} ALL=(ALL) NOPASSWD: ALL" | sudo su -c 'EDITOR="tee -a" visudo'

EndOfScript

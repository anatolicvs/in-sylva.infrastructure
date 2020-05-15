#!/bin/bash
#
#script used to change the docker version installed on the running machine
#
# Author: philippe.clastre at inra.fr
# v1.0
# May 2020
#
#
# Variables to check before launching this script !
#
#DVTI=18.09.9  # new docker version to install
DCVTI=1.25.5  # new docker-compose version to install
DO_NOTHING=false    # set to false to activate real OS modification; set to true to simulate what will be done
#

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ "$DO_NOTHING" == "true" ]; then
  echo "Simulation mode ... Nothing done on this os"
fi


echo "Step 0: Controling no running containers ..."
if [ $(docker container ls -a | grep -v CREATED | wc -l ) -ne 0 ]; then
  echo "Please stop and delete all containers and relaunch the script"
  exit
fi
if [ $(docker ps -a | grep -v CREATED | wc -l ) -ne 0 ]; then
  echo "Please stop and delete all containers and relaunch the script"
  exit
fi

echo "########################################################"
echo "Step 1: deleting all containers, images and volumes ..."
if [ "$DO_NOTHING" == "false"  ]; then
	docker system prune -a
	docker volume prune
	echo "Step 1: Done"
fi

echo "########################################################"
echo "Step 2:  uninstall docker packages"
list=$(dpkg -l | grep docker | awk '{print $2}')
for i in $list
do
  echo "Uninstalling package $i ..."
  if [ "$DO_NOTHING" == "false" ]; then
    apt-get purge -y $i
    apt-get autoremove -y --purge $i
  fi
done
list=$(dpkg -l | grep containerd.io | awk '{print $2}')
for i in $list
do
  echo "Uninstalling package $i ..."
  if [ "$DO_NOTHING" == "false" ]; then
    apt-get purge -y $i
    apt-get autoremove -y --purge $i
  fi
done


echo "########################################################"
echo "Step 3:  uninstall docker-compose"
which docker-compose > /dev/null
if [ ! $? -eq 0 -a "$DO_NOTHING" == "false" ]; then
  rm $(which docker-compose)
fi

echo "########################################################"
echo "Step 4: Install docker new version: $DVTI"

if [ "$DO_NOTHING" == "false" ]; then
  apt-get update 
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
  apt-get update
  echo "==========........................................==========="
  echo "Here is the list of docker engine versions available for this machine"
  apt-cache madison docker-ce
  echo "==========........................................==========="
  echo "Enter the version string (second column): "
  read DVTI
  apt-get install docker-ce=${DVTI} docker-ce-cli=${DVTI} containerd.io
  echo "Step 4: Done"
fi

echo "########################################################"
echo "Step 5: Install docker-compose new version: $DCVTI"

if [ "$DO_NOTHING" == "false" ]; then
  curl -L https://github.com/docker/compose/releases/download/$DCVTI/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo "Step 5: Done"
fi

echo "########################################################"
echo "Step 6: Gives docker rights for user pclastre"
usermod -aG docker pclastre
echo "Step 6: Done"


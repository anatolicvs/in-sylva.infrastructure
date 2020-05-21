#!/bin/bash

# echo -n "Enter the name of public key (ex:id_ed25519): "
# read publickey
nmcli dev show | grep 'IP4.DNS'

if [ "$1" == "" ]
then
     set $"id_ed25519"
     echo "Setting ssh key to default: $1"
fi

if [ ! -e ~/.ssh/$1.pub ]; then
  echo "ERROR: the $1 key file does not exit. Check and relaunch ..."
  exit
else
  echo "Key file: $1"
fi

# Control for elasticsearch and host parameters
val=0$(grep vm.max_map_count /etc/sysctl.conf | awk -F"=" '{print $2}')
if [ $val -lt 262144 ]; then
  echo "ERROR: insylva infrastructure and particularly elasticsearc component won't work"
  echo "        You must add/increase the /etc/sysctl.conf parameter vm.max_map_count to at least 262144"
  echo "        So add a line like vm.max_map_count=262144 at the end of the file /etc/sysctl.conf"
  exit
fi

echo $publickey
echo "IN-SYLVA project 'Docker images' list: "
echo "        --> gatekeeper, keycloak, login, portal, postgresql, sourceman, search, search-api, doc"
echo ""
echo -n "Enter the name of docker image you want to build locally: (ex:gatekeeper or || all): "

read imageName

if [ "$imageName" == "" ]
then
    set $"all"
fi

case $imageName in
    "gatekeeper")
        sh ./gatekeeper/build.sh $1
        wait 
        echo -e $"gatekeeper image Successfully built\n"
        ;;
    "keycloak")
        sh ./keycloak/build.sh $1
        wait
        echo -e $"keycloak image Successfully built\n"
        ;;
    "login")
        sh ./login/build.sh $1
        wait
        echo -e $"login image Successfully built\n"
        ;;
    "portal")
        sh ./portal/build.sh $1
        wait
        echo -e $"portal image Successfully built\n"
        ;;
    "postgresql")
        sh ./postgresql/build.sh $1
        wait
        echo -e $"postgresql image Successfully built\n"
        ;;
    "sourceman")
       sh ./source.manager/build.sh $1
       wait
       echo -e $"source.manager image Successfully built\n"
       ;;
    "search")
       sh ./search/build.sh $1
       wait
       echo -e $"search image Successfully built\n"
       ;;
    "search-api")
       sh ./search.api/build.sh $1
       wait
       echo -e $"search.api image Successfully built\n"
       ;;
    "doc")
      sh ./doc/build.sh $1
      wait
      echo $"doc image Successfully built\n"
      ;;
    "all")
      sh ./gatekeeper/build.sh $1
      wait 
      echo -e $"gatekeeper image Successfully built\n"
      sh ./keycloak/build.sh $1
      wait
      echo -e $"keycloak image Successfully built\n"
      sh ./login/build.sh $1
      wait
      echo -e $"login image Successfully built\n"
      sh ./portal/build.sh $1
      wait
      echo -e $"portal image Successfully built\n"
      sh ./postgresql/build.sh $1
      wait
      echo -e $"postgresql image Successfully built\n"
      sh ./source.manager/build.sh $1
      wait
      echo -e $"source.manager image Successfully built\n"
      sh ./search/build.sh $1
      wait
      echo -e $"search image Successfully built\n"
      sh ./search.api/build.sh $1
      wait
      echo -e $"search.api image Successfully built\n"
      sh ./doc/build.sh $1
      wait
      echo $"doc image Successfully built\n"
      ;;
    *)
      echo "Option not allowed. Restart the build script and read carefully !"
      ;;
esac
shift

#!/bin/bash


# echo -n "Enter the name of public key (ex:id_ed25519): "
# read publickey
nmcli dev show | grep 'IP4.DNS'

if [$1 -eq ""]
then
     set $"id_ed25519"
fi

echo $publickey
echo -n "Enter the name of docker image name which is wanted to build locally: (ex:gatekeeper or || all): "
read imageName

if [$imageName -eq ""]
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
    *)
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
esac
shift
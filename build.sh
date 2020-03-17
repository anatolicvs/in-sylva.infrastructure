#!/bin/bash

if [$1 -eq ""]
then
    set "id_ed25519"
fi

sh ./gatekeeper/build.sh $1
wait 
echo "gatekeeper image Successfully built"
sh ./keycloak/build.sh $1
wait
echo "keycloak image Successfully built"
sh ./login/build.sh $1
wait
echo "login image Successfully built"
sh ./portal/build.sh $1
wait
echo "portal image Successfully built"
sh ./postgresql/build.sh $1
wait
echo "postgresql image Successfully built"
sh ./source.manager/build.sh $1
echo "source.manager image Successfully built"
wait
sh ./doc/build.sh $1
echo "doc image Successfully built"
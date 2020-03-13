#!/bin/bash

sh ./gatekeeper/build.sh
wait 
echo "gatekeeper image Successfully built"
sh ./keycloak/build.sh
wait
echo "keycloak image Successfully built"
sh ./login/build.sh
wait
echo "login image Successfully built"
sh ./portal/build.sh
wait
echo "portal image Successfully built"
sh ./postgresql/build.sh
wait
echo "postgresql image Successfully built"
sh ./source.manager/build.sh
echo "source.manager image Successfully built"
wait
sh ./doc/build.sh
echo "doc image Successfully built"
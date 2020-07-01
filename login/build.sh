#!/bin/bash

while [ "$1" != "" ]; do
   SSH_KEY=$(cat ~/.ssh/$1)
   SSH_KEY_PASSPHRASE=$(cat ~/.ssh/$1.pub)
    # Shift all the parameters down by one
    shift
done

echo $IN_SYLVA_SEARCH_HOST

docker build --no-cache --build-arg SSH_KEY="$SSH_KEY" --build-arg SSH_KEY_PASSPHRASE="$SSH_KEY_PASSPHRASE" \
 --build-arg MODE_ENV="production" \
 --build-arg IN_SYLVA_CLIENT_ID="in-sylva.user.app" \
 --build-arg IN_SYLVA_GRANT_TYPE="password" \
 --build-arg IN_SYLVA_REALM="in-sylva" \
 --build-arg IN_SYLVA_KEYCLOAK_HOST="w3.avignon.inra.fr/bas_insylva/search/keycloak" \
 --build-arg IN_SYLVA_KEYCLOAK_PORT="7000" \
 --build-arg IN_SYLVA_PORTAL_HOST="w3.avignon.inra.fr/bas_insylva/portal" \
 --build-arg IN_SYLVA_SEARCH_HOST="w3.avignon.inra.fr/bas_insylva/search" \
 --build-arg IN_SYLVA_GATEKEEPER_HOST="w3.avignon.inra.fr/bas_insylva/portal/gatekeeper" \
 --build-arg IN_SYLVA_GATEKEEPER_PORT="4000" \
 --tag in-sylva.user.login ./login/.
 
 # Note: The variables above could not set values from ipconfig.txt by build.sh
 # Please notice, the variables should be set as aboves.

 # --build-arg IN_SYLVA_KEYCLOAK_HOST=$IN_SYLVA_KEYCLOAK_HOST \
 # --build-arg IN_SYLVA_KEYCLOAK_PORT=$IN_SYLVA_KEYCLOAK_PORT \
 # --build-arg IN_SYLVA_PORTAL_HOST=$IN_SYLVA_PORTAL_HOST  \
 # --build-arg IN_SYLVA_PORTAL_PORT=$IN_SYLVA_PORTAL_PORT \
 # --build-arg IN_SYLVA_SEARCH_HOST=$IN_SYLVA_SEARCH_HOST \
 # --build-arg IN_SYLVA_SEARCH_PORT=$IN_SYLVA_SEARCH_PORT \
 # --build-arg IN_SYLVA_GATEKEEPER_HOST=$IN_SYLVA_GATEKEEPER_HOST \
 # --build-arg IN_SYLVA_GATEKEEPER_PORT=$IN_SYLVA_GATEKEEPER_PORT \
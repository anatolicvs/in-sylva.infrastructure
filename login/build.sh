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
 --build-arg IN_SYLVA_KEYCLOAK_HOST="$IN_SYLVA_KEYCLOAK_HOST_FOR_LOGIN" \
 --build-arg IN_SYLVA_KEYCLOAK_PORT="7000" \
 --build-arg IN_SYLVA_PORTAL_HOST="$IN_SYLVA_PORTAL_HOST_FOR_LOGIN" \
 --build-arg IN_SYLVA_SEARCH_HOST="$IN_SYLVA_SEARCH_HOST_FOR_LOGIN" \
 --build-arg IN_SYLVA_GATEKEEPER_HOST="$IN_SYLVA_GATEKEEPER_HOST_FOR_LOGIN" \
 --build-arg IN_SYLVA_GATEKEEPER_PORT="4000" \
 --tag in-sylva.user.login ./login/.
 

 # Variables used in this script are defined by the main build.sh
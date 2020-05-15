#!/bin/bash

while [ "$1" != "" ]; do
   SSH_KEY=$(cat ~/.ssh/$1)
   SSH_KEY_PASSPHRASE=$(cat ~/.ssh/$1.pub)
    # Shift all the parameters down by one
    shift
done

docker build --no-cache --network=host --no-cache --build-arg SSH_KEY="$SSH_KEY" --build-arg SSH_KEY_PASSPHRASE="$SSH_KEY_PASSPHRASE" \
 --build-arg IN_SYLVA_GATEKEEPER_HOST="0.0.0.0" \
 --build-arg IN_SYLVA_GATEKEEPER_PORT="4000" \
 --build-arg IN_SYLVA_KEYCLOAK_HOST="0.0.0.0" \
 --build-arg IN_SYLVA_KEYCLOAK_PORT="3000" \
 --build-arg IN_SYLVA_SEARCH_HOST="0.0.0.0" \
 --build-arg IN_SYLVA_SEARCH_PORT="3001" \
 --build-arg IN_SYLVA_PORTAL_HOST="0.0.0.0" \
 --build-arg IN_SYLVA_PORTAL_PORT="3000" \
 --build-arg IN_SYLVA_CLIENT_ID="in-sylva.user.app" \
 --build-arg IN_SYLVA_GRANT_TYPE="password" \
 --build-arg IN_SYLVA_REALM="in-sylva" \
 --tag in-sylva.user.login ./login/.



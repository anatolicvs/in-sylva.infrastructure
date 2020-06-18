#!/bin/bash

while [ "$1" != "" ]; do
   SSH_KEY=$(cat ~/.ssh/$1)
   SSH_KEY_PASSPHRASE=$(cat ~/.ssh/$1.pub)
    # Shift all the parameters down by one
    shift
done



docker build --no-cache --build-arg SSH_KEY="$SSH_KEY" --build-arg SSH_KEY_PASSPHRASE="$SSH_KEY_PASSPHRASE" \
 --build-arg MODE_ENV="production" \
 --build-arg IN_SYLVA_CLIENT_ID="in-sylva.user.app" \
 --build-arg IN_SYLVA_GRANT_TYPE="password" \
 --build-arg IN_SYLVA_REALM="in-sylva" \
 --tag in-sylva.user.login ./login/. \
 --build-arg IN_SYLVA_KEYCLOAK_HOST=$IN_SYLVA_KEYCLOAK_HOST \
 --build-arg IN_SYLVA_KEYCLOAK_PORT=$IN_SYLVA_KEYCLOAK_PORT \
 --build-arg IN_SYLVA_PORTAL_HOST=$IN_SYLVA_PORTAL_HOST  \
 --build-arg IN_SYLVA_PORTAL_PORT=$IN_SYLVA_PORTAL_PORT \
 --build-arg IN_SYLVA_SEARCH_HOST=$IN_SYLVA_SEARCH_HOST \
 --build-arg IN_SYLVA_SEARCH_PORT=$IN_SYLVA_SEARCH_PORT \
 --build-arg IN_SYLVA_GATEKEEPER_HOST=$IN_SYLVA_GATEKEEPER_HOST \
 --build-arg IN_SYLVA_GATEKEEPER_PORT=$IN_SYLVA_GATEKEEPER_PORT \
 --build-arg IN_SYLVA_LOGIN_HOST=$IN_SYLVA_LOGIN_HOST \
 --build-arg IN_SYLVA_LOGIN_PORT=$IN_SYLVA_LOGIN_PORT



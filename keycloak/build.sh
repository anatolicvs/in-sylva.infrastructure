#!/bin/bash

docker build -t in-sylva.keycloak --build-arg SSH_KEY="$(cat ~/.ssh/id_ed25519)" --build-arg SSH_KEY_PASSPHRASE="$(cat ~/.ssh/id_ed25519.pub)" --build-arg KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" --squash .


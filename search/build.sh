#!/bin/bash

while [ "$1" != "" ]; do
   SSH_KEY=$(cat ~/.ssh/$1)
   SSH_KEY_PASSPHRASE=$(cat ~/.ssh/$1.pub)
    # Shift all the parameters down by one
    shift
done

docker build --build-arg SSH_KEY="$SSH_KEY" --build-arg SSH_KEY_PASSPHRASE="$SSH_KEY_PASSPHRASE" --tag in-sylva.search ./search/


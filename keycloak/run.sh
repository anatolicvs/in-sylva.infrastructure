#!/bin/bash

docker run -d -p 7000:8080 -e KEYCLOAK_USER=in-sylva-admin -e KEYCLOAK_PASSWORD=v2kGBDUaGjXK2VuPyf5R64VS in-sylva.keycloak:latest
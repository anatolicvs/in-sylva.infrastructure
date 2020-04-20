#!/bin/bash

docker exec -it in-sylva.keycloak /bin/bash -c "/opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/keycloak/auth --realm master --user insylva_admin --password v2kGBDUaGjXK2VuPyf5R64VS"
docker exec -it in-sylva.keycloak /bin/bash -c "/opt/jboss/keycloak/bin/kcadm.sh create realms -f /home/realms/realm-export.json
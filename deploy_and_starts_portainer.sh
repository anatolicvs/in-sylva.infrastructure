#!/bin/bash
#

# first run in order to install 2.4-alpine image if it does not previously exist
docker run --rm httpd:2.4-alpine htpasswd -nbB admin admin > /dev/null
# generate password for admin
docker run --rm httpd:2.4-alpine htpasswd -nbB admin admin | cut -d ":" -f 2 > /tmp/portainer_password
#launch  portainer
docker container ls -a | grep insylva.portainer > /dev/null
if [ $? -eq 0 ]; then
  echo "Suppression ancien conteneur insylva.portainer ..."
  docker container rm insylva.portainer
fi

docker run -d -p 9000:9000 -p 8000:8000 \
	--name insylva.portainer \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_data:/data \
	portainer/portainer


echo "Portainer lancé..."

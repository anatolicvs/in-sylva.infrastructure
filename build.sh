#!/bin/bash

# echo -n "Enter the name of public key (ex:id_ed25519): "
# read publickey
# nmcli dev show | grep 'IP4.DNS'  # check ip address due to docker dynamic ip allocation for the containers

Usage(){ 
  echo "##############$0 USAGE########################"
  echo "Script $0 -k <ssh_key_file> -e {dev|prod} <-d domain_name>" 
  echo "Use it to build in-sylva docker infrastructure" 
  echo "##############################################" 
  echo "$0 -k id_rsa -e dev" 
  echo "           * Starts building for development; " 
  echo "$0 -k id_rsa -e prod -d w3.avignon.inra.fr/bas_insylva/ -ip 147.100.20.44 -p 8081"
  echo "           * The portal page would be accessible with URL: http://w3.avignon.inra.fr/bas_insylva/portal/" 
  echo "           * The login page will be http://147.100.20.44:8081"
  echo "##############################################" 
  echo "Args:" 
  echo "-k <ssh_key_file>: mandatory. id_rsa keyfile should exits in ~/.ssh/ user directory " 
  echo "-e {dev|prod}: mandatory. Switching environment. If <prod> deployment is choosen, you must precise -d argument" 
  echo "-d domain_name: mandatory in production deployment. Precise the base URL which will be use to contact application." 
  echo "    domain_name should appear as <domain>/<path1>/<path2>/"
  echo "    Example: w3.avignon.inra.fr/bas_insylva/portal/"
  echo "-ip <ip address>: mandatory in production deployment. Precise the ip address of the server (used for direct access to search application in production mode)"
  echo "-p <port number>: mandatory in production deployment. Precise the port number of the server (used for direct access to login application in production mode)"
  echo "##############################################" 
  exit 
}

while [ $# != 0 ];do
  opt="$1"
  case $opt in
    -k)
      shift
      if [ ! -e ~/.ssh/$1.pub ]; then
        echo "ERROR: the $1 key file does not exit. Check and relaunch ..."
        Usage 
        exit
      else
	KEY=$1
        echo "Key file: $KEY"
      fi;;
    -e)
      shift
      case $1 in
        dev) MODE=dev;;
        prod) MODE=prod;;
        *) 
          echo "ERROR: unknown $1 mode for -t option. Check and relaunch ..."
          Usage
          exit
      esac;;
    -d)
      shift
      DOMAIN=$1
      echo "INFO: using $DOMAIN as domaine name";;
    -ip)
      shift
      LOGINSERVER=$1
      echo "INFO: server used is $LOGINSERVER";;
    -p)  
      shift
      LOGINPORT=$1
      echo "INFO: port used is $LOGINPORT";;
  esac 
  shift  
done

if [ -z $MODE ]; then 
  echo "ERROR: the -e option is mandatory. Check Usage and relaunch"
  Usage
  exit
fi

if [ "$MODE" == "prod" ]; then
	echo -n "Would do like to reinitialize all docker volumes (this will delete previous data) ? [o/n] "
	read rep
	if [ "$rep" == "o" ]; then
		  docker-compose down
		  docker system prune -f
	fi
fi

if [ "$MODE" == "prod" -a -z "$DOMAIN" ]; then
  DOMAIN="w3.avignon.inra.fr/bas_insylva/"
  echo "INFO: no domain defined. Using $DOMAIN"
fi

if [ "$MODE" == "dev" -a -z "$DOMAIN" ]; then
  DOMAIN="localhost"
  echo "INFO: no domain defined. Using $DOMAIN"
fi

if [ "$MODE" == "prod" -a -z "$LOGINSERVER" ]; then
  LOGINSERVER="147.100.20.44"
  echo "INFO: no ip address defined. Using $LOGINSERVER"
fi

if [ "$MODE" == "prod" -a -z "$LOGINPORT" ]; then
  LOGINPORT="3001"
  echo "INFO: no port defined. Using $LOGINPORT"
fi

# checking $DOMAIN and creating PATH for redirections
if [ ! -z "$DOMAIN" ]; then
  NGINXCONF=$(echo $DOMAIN | cut -d/ -f2- | sed -e 's,^,/,' | sed -e 's,/$,,')
  echo "INFO: NGINX_BASE_URL = $NGINXCONF"
fi

# creating .env and nginx.conf files from generic version 
rm -f search/.env portal/.env search/nginx/nginx.conf portal/nginx/nginx.conf login/nginx/nginx.conf

cp search/.env_generic search/.env
cp portal/.env_generic portal/.env
cp search/nginx/nginx_generic.conf search/nginx/nginx.conf 
cp portal/nginx/nginx_generic.conf portal/nginx/nginx.conf 
cp login/nginx/nginx_generic.conf login/nginx/nginx.conf
if [ "$MODE" == "prod" ];then
  SERVER_IP="147.100.20.44"
  # search customization
  sed -i -e "s,server_name .,server_name ${DOMAIN}search/," search/nginx/nginx.conf
  sed -i -e "s,_HOST=/,_HOST=${NGINXCONF}/search/," search/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_LOGIN_HOST=.*,REACT_APP_IN_SYLVA_LOGIN_HOST=http://${DOMAIN}login/," search/.env

  # portal customization
  sed -i -e "s,server_name .,server_name ${DOMAIN}portal/," portal/nginx/nginx.conf
  sed -i -e "s,_HOST=/,_HOST=${NGINXCONF}/portal/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_LOGIN_HOST=.*,REACT_APP_IN_SYLVA_LOGIN_HOST=http://${DOMAIN}login/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_KIBANA_URL=.*,REACT_APP_IN_SYLVA_KIBANA_URL=http://${SERVER_IP}:5601/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_POSTGRESQL_URL=.*,REACT_APP_IN_SYLVA_POSTGRESQL_URL=http://${SERVER_IP}:5050/login?next=%2F/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_MONGODB_URL=.*,REACT_APP_IN_SYLVA_MONGODB_URL=http://${SERVER_IP}:8881/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_ELASTICSEARCH_URL=.*,REACT_APP_IN_SYLVA_ELASTICSEARCH_URL=http://${SERVER_IP}:9200/," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_KEYCLOAK_URL=.*,REACT_APP_IN_SYLVA_KEYCLOAK_URL=http://${SERVER_IP}:7000/keycloak/auth//," portal/.env
  sed -i -e "s,REACT_APP_IN_SYLVA_PORTAINER_URL=.*,REACT_APP_IN_SYLVA_PORTAINER_URL=http://${SERVER_IP}:9000/#/init/admin/," portal/.env


  # login customization 
  sed -i -e "s,server_name .,server_name ${DOMAIN}login/," login/nginx/nginx.conf
fi

# login customization
cp ipconfig_generic.txt ipconfig.txt
if [ "$MODE" == "prod" ]; then
  sed -i -e "s,IP_ADDRESS,${LOGINSERVER}," ipconfig.txt
  sed -i -e "s,DOMAIN$,${DOMAIN}," ipconfig.txt
else
  sed -i -e "s/IP_ADDRESS/0.0.0.0/" ipconfig.txt
  sed -i -e "s/DOMAIN/0.0.0.0/" ipconfig.txt
fi

export IN_SYLVA_KEYCLOAK_HOST=$(grep IN_SYLVA_KEYCLOAK_HOST ipconfig.txt| awk '{print $2}')
export IN_SYLVA_KEYCLOAK_PORT=$(grep IN_SYLVA_KEYCLOAK_PORT ipconfig.txt| awk '{print $2}')
export IN_SYLVA_PORTAL_HOST=$(grep IN_SYLVA_PORTAL_HOST ipconfig.txt| awk '{print $2}')
export IN_SYLVA_PORTAL_PORT=$(grep IN_SYLVA_PORTAL_PORT ipconfig.txt| awk '{print $2}')
export IN_SYLVA_GATEKEEPER_HOST=$(grep IN_SYLVA_GATEKEEPER_HOST ipconfig.txt| awk '{print $2}')
export IN_SYLVA_GATEKEEPER_PORT=$(grep IN_SYLVA_GATEKEEPER_PORT ipconfig.txt| awk '{print $2}')
export IN_SYLVA_SEARCH_PORT=$(grep IN_SYLVA_SEARCH_PORT ipconfig.txt| awk '{print $2}')
export IN_SYLVA_SEARCH_HOST=$(grep IN_SYLVA_SEARCH_HOST ipconfig.txt| awk '{print $2}')
export IN_SYLVA_SEARCH_PORT=$(grep IN_SYLVA_LOGIN_PORT ipconfig.txt| awk '{print $2}')
export IN_SYLVA_SEARCH_HOST=$(grep IN_SYLVA_LOGIN_HOST ipconfig.txt| awk '{print $2}')
# Attention, you can generate reCAPTCHA_site_key by following this link https://www.google.com/u/3/recaptcha/admin/site/ with In-Sylva gmail account that is named insylva2020@gmail.com 
export IN_SYLVA_reCAPTCHA_site_key="6LflFcoZAAAAABawkeag3uWRAdeFZ9uSB7vJoeTg"

if [ "$MODE" == "dev" ]; then
  export IN_SYLVA_KEYCLOAK_HOST_FOR_LOGIN="${DOMAIN}:8081/keycloak" 
  export IN_SYLVA_PORTAL_HOST_FOR_LOGIN="${DOMAIN}:3000" 
  export IN_SYLVA_SEARCH_HOST_FOR_LOGIN="${DOMAIN}:3001" 
  export IN_SYLVA_GATEKEEPER_HOST_FOR_LOGIN="${DOMAIN}:8081/gatekeeper" 
else 
  export IN_SYLVA_KEYCLOAK_HOST_FOR_LOGIN="${DOMAIN}login/keycloak"  
  export IN_SYLVA_PORTAL_HOST_FOR_LOGIN="${DOMAIN}portal" 
  export IN_SYLVA_SEARCH_HOST_FOR_LOGIN="${DOMAIN}search" 
  export IN_SYLVA_GATEKEEPER_HOST_FOR_LOGIN="${DOMAIN}login/gatekeeper" 
fi

echo $IN_SYLVA_KEYCLOAK_HOST_FOR_LOGIN
echo $IN_SYLVA_PORTAL_HOST_FOR_LOGIN
echo $IN_SYLVA_SEARCH_HOST_FOR_LOGIN
echo $IN_SYLVA_GATEKEEPER_HOST_FOR_LOGIN

# Control for elasticsearch and host parameters
val=0$(grep vm.max_map_count /etc/sysctl.conf | awk -F"=" '{print $2}')
if [ $val -lt 262144 ]; then
  echo "ERROR: insylva infrastructure and particularly elasticsearc component won't work"
  echo "        You must add/increase the /etc/sysctl.conf parameter vm.max_map_count to at least 262144"
  echo "        So add a line like vm.max_map_count=262144 at the end of the file /etc/sysctl.conf"
  exit
fi

echo $publickey
echo "IN-SYLVA project 'Docker images' list: "
echo "        --> gatekeeper, keycloak, login,login-server ,portal, postgresql, sourceman, search, search-api, doc"
echo ""
echo -n "Enter the name of docker image you want to build locally: (ex:gatekeeper or || all): "

read imageName

# accepting image name with uppercase: converting them to lower !
imageName=$(echo "$imageName" | tr '[:upper:]' '[:lower:]')

if [ "$imageName" == "" ]
then
    set $"all"
fi


case $imageName in
    "gatekeeper")
        sh ./gatekeeper/build.sh $KEY
        wait 
        echo -e $"gatekeeper image Successfully built\n"
        ;;
    "keycloak")
        sh ./keycloak/build.sh $KEY
        wait
        echo -e $"keycloak image Successfully built\n"
        ;;
    "login")
        sh ./login/build.sh $KEY
        wait
        echo -e $"login image Successfully built\n"
        ;;
    "login-server")
        sh ./login/nginx/build.sh $KEY
        wait
        echo -e $"login-server image Successfully built\n"
        ;;
    "portal")
        sh ./portal/build.sh $KEY
        wait
        echo -e $"portal image Successfully built\n"
        ;;
    "postgresql")
        sh ./postgresql/build.sh $KEY
        wait
        echo -e $"postgresql image Successfully built\n"
        ;;
    "sourceman")
       sh ./source.manager/build.sh $KEY
       wait
       echo -e $"source.manager image Successfully built\n"
       ;;
    "search")
       sh ./search/build.sh $KEY
       wait
       echo -e $"search image Successfully built\n"
       ;;
    "search-api")
       sh ./search.api/build.sh $KEY
       wait
       echo -e $"search.api image Successfully built\n"
       ;;
    "doc")
      sh ./doc/build.sh $KEY
      wait
      echo $"doc image Successfully built\n"
      ;;
    "all")
      sh ./gatekeeper/build.sh $KEY
      wait 
      echo -e $"gatekeeper image Successfully built\n"
      sh ./keycloak/build.sh $KEY
      wait
      echo -e $"keycloak image Successfully built\n"
      sh ./login/build.sh $KEY
      wait
      echo -e $"login image Successfully built\n"
      sh ./portal/build.sh $KEY
      wait
      echo -e $"portal image Successfully built\n"
      sh ./postgresql/build.sh $KEY
      wait
      echo -e $"postgresql image Successfully built\n"
      sh ./source.manager/build.sh $KEY
      wait
      echo -e $"source.manager image Successfully built\n"
      sh ./search/build.sh $KEY
      wait
      echo -e $"search image Successfully built\n"
      sh ./search.api/build.sh $KEY
      wait
      echo -e $"search.api image Successfully built\n"
      sh ./doc/build.sh $KEY
      wait
      echo $"doc image Successfully built\n"
      sh ./login/nginx/build.sh $KEY
      wait
      echo -e $"login-server image Successfully built\n"
      ;;
    *)
      echo "Option not allowed. Restart the build script and read carefully !"
      ;;
esac
shift

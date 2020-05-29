#!/bin/bash

# echo -n "Enter the name of public key (ex:id_ed25519): "
# read publickey
# nmcli dev show | grep 'IP4.DNS'  # philippe: don't understand what it is for ...commented

Usage(){ 
  echo "##############$0 USAGE########################"
  echo "Script $0 -k <ssh_key_file> -t {dev|prod} <-d domain_name>" 
  echo "Use it to build in-sylva docker infrastructure" 
  echo "##############################################" 
  echo "$0 -k id_rsa -t dev  : start building for development; " 
  echo "$0 -k id_rsa -t prod -d w3.avignon.inra.fr/bas_insylva/portal/: start building for production; The portal page would be accessible thru URL: http://w3.avignon.inra.fr/bas_insylva/portal/" 
  echo "##############################################" 
  echo "Args:" 
  echo "-k <ssh_key_file>: mandatory. id_rsa keyfile should exits in ~/.ssh/ user directory " 
  echo "-t {dev|prod}: mandatory. If <prod> deployment is choosen, you must precise -d argument" 
  echo "-d domain_name: mandatory in production deploiement. Precise the base URL which will be use to contact application." 
  echo "    domain_name should appear as <domain>/<path1>/<path2>/"
  echo "    Example: w3.avignon.inra.fr/bas_insylva/portal/"
  echo "##############################################" 
  exit 
}

while [[ $# != 0 ]];do
  opt="$1"
  case $opt in
    -k)
      shift
      if [ ! -e ~/.ssh/$1.pub ]; then
        echo "ERROR: the $1 key file does not exit. Check and relaunch ..."
        Usage 
        exit
      else
        echo "Key file: $1"
      fi;;
    -t)
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
  esac 
  shift  
done

if [ -z $MODE ]; then 
  echo "ERROR: the -t option is mandatory. Check Usage and relaunch"
  Usage
  exit
fi

if [ "$MODE" == "prod" -a -z "$DOMAIN" ]; then
  echo "ERROR: when using prod mode, you must specify a domain name. Check Usage and relaunch"
  Usage
  exit
fi

# checking $DOMAIN and creating PATH for redirections
if [ ! -z "$DOMAIN" ]; then
  NGINXCONF=$(echo $DOMAIN | cut -d/ -f2- | sed -e 's,^,/,' | sed -e 's,/$,,')
  echo "INFO: NGINX_BASE_URL = $NGINXCONF"
fi

# creating .env and nginx.conf files from generic version 
rm -f search/.env portal/.env search/nginx/nginx.conf portal/nginx/nginx.conf

cp search/.env_generic search/.env
cp portal/.env_generic portal/.env
cp search/nginx/nginx_generic.conf search/nginx/nginx.conf 
cp portal/nginx/nginx_generic.conf portal/nginx/nginx.conf 
if [ "$MODE" == "prod" ];then
  sed -i -e "s,server_name .,server_name $DOMAIN," search/nginx/nginx.conf
  sed -i -e "s,server_name .,server_name $DOMAIN," portal/nginx/nginx.conf

  sed -i -e "s,_HOST=/,_HOST=${NGINXCONF}/," search/.env
  sed -i -e "s,_HOST=/,_HOST=${NGINXCONF}/," portal/.env
fi



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
echo "        --> gatekeeper, keycloak, login, portal, postgresql, sourceman, search, search-api, doc"
echo ""
echo -n "Enter the name of docker image you want to build locally: (ex:gatekeeper or || all): "

read imageName

if [ "$imageName" == "" ]
then
    set $"all"
fi

case $imageName in
    "gatekeeper")
        sh ./gatekeeper/build.sh $1
        wait 
        echo -e $"gatekeeper image Successfully built\n"
        ;;
    "keycloak")
        sh ./keycloak/build.sh $1
        wait
        echo -e $"keycloak image Successfully built\n"
        ;;
    "login")
        sh ./login/build.sh $1
        wait
        echo -e $"login image Successfully built\n"
        ;;
    "portal")
        sh ./portal/build.sh $1
        wait
        echo -e $"portal image Successfully built\n"
        ;;
    "postgresql")
        sh ./postgresql/build.sh $1
        wait
        echo -e $"postgresql image Successfully built\n"
        ;;
    "sourceman")
       sh ./source.manager/build.sh $1
       wait
       echo -e $"source.manager image Successfully built\n"
       ;;
    "search")
       sh ./search/build.sh $1
       wait
       echo -e $"search image Successfully built\n"
       ;;
    "search-api")
       sh ./search.api/build.sh $1
       wait
       echo -e $"search.api image Successfully built\n"
       ;;
    "doc")
      sh ./doc/build.sh $1
      wait
      echo $"doc image Successfully built\n"
      ;;
    "all")
      sh ./gatekeeper/build.sh $1
      wait 
      echo -e $"gatekeeper image Successfully built\n"
      sh ./keycloak/build.sh $1
      wait
      echo -e $"keycloak image Successfully built\n"
      sh ./login/build.sh $1
      wait
      echo -e $"login image Successfully built\n"
      sh ./portal/build.sh $1
      wait
      echo -e $"portal image Successfully built\n"
      sh ./postgresql/build.sh $1
      wait
      echo -e $"postgresql image Successfully built\n"
      sh ./source.manager/build.sh $1
      wait
      echo -e $"source.manager image Successfully built\n"
      sh ./search/build.sh $1
      wait
      echo -e $"search image Successfully built\n"
      sh ./search.api/build.sh $1
      wait
      echo -e $"search.api image Successfully built\n"
      sh ./doc/build.sh $1
      wait
      echo $"doc image Successfully built\n"
      ;;
    *)
      echo "Option not allowed. Restart the build script and read carefully !"
      ;;
esac
shift

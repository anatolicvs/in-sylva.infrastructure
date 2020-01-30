# IN-SYLVA infrastructure installation (debian server)

Here are instructions to deploy IN-SYLVA infrastructure on a debian server.

In the rest of this document, the server name will be "localhost".
You should change it according to your needs.

Fully tested on Debian Jessie distribution

## Step 1: installing docker-engine 

Follow instructions given on [this docker page](https://docs.docker.com/install/linux/docker-ce/debian/). Nothing to change !!
Recommanded version: 

> Docker version 19.03.5, build 633a0ea838

Make it run each time the system restart

    systemctl enable docker


## Step 2: installing docker-compose
Follow instructions given on [this docker page](https://docs.docker.com/compose/install/). 

Sometimes, this process may fail (the file is big).
Retry again later !

## Step 3: about security

Following explanation findable [here](https://docs.docker.com/install/linux/linux-postinstall/), you should create a "docker group" and a your account in this group.
Then your account will be allowed to run docker commands. Find complete security concern in docker documentation given.

    export A_USER=a_user_login_able_to_run_docker_commands
    groupadd docker
    usermod -aG docker $A_USER
    newgrp docker


##  Step 4: Getting tools from gitlab

All code are stored on the forgeMIA gitlab repository. It is accessible through this URL: [https://forgemia.inra.fr](https://forgemia.inra.fr/)
The IN-SYLVA project is stored as a "private project". Therefore one need an account to gain access. Please follow instructions given on the main page, using the "sign in"  (connexion SSO) process [uses your ldap authentication data]. 
Create a dedicated directory with enough space on your server. 
For the rest of this document, we will guess that the IN-SYLVA infrastructure will be stored in a directory named "$insylva_dir".

Gain access to the forge, by creating a SSH public key on the server you will use to run in-sylva. The first step is to create an account to the forgemia, then ask in-sylva project manager to allow you (it's a private project). All instructions
to create your key pair is given in the "user settings"/SSH keys part of the forgemia web interface.

    export insylva_dir=/usr/local/insylva
    cd $insylva_dir
    git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.infrastructure.git

After this, all necessary packages will be available on your server

### Building in-sylva.keycloak:latest
Building Keycloack docker image. This tool is needed to manage authentication for all IN-SYLVA tools.

    cd in-sylva.infrastructure/keycloak && sh ./build.sh 

### Building in-sylva-postgres:latest
Building PostgreSQL docker image. The SGBD will be used to store various data for IN-SYLVA SI.

    cd ..  && cd postgresql && sh ./build.sh


## Step 5: Starting IN-SYLVA SI

    cd .. && docker-compose --compatibility up -d

## Step 6: Testing IN-SYLVA SI

Try to reach keycloack at http://localhost:7000/auth/
Try to reach pgadmin4 at http://localhost:5050/auth/

## Managing errors
What to do if things go wrong ?
1. Call the police
2. Call Ozkan


## Customizing / questions

##### Docker-compose questions
*   mongo database name: inra_paca: should be change to insylvadb or insylva_mongodb
*   mongo user name: inra_paca_mongoc: should be change to insylva or insylva_mongo_user
*   pgadmin_default_email: user should be incited to change to something else. What about the password associated with it ?
*   which instructions if we have already a postgresql server running somewhere and want to use it ? unplug the postgre container, and probably pgadmin4 also (as we may have another instance elsewhere). Need to create empty databse using the file data.sql for the structure ? Declare an account allowed to create a new database in the pgsql instance ... 

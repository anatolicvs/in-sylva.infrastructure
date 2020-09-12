# In-Sylva Infrastructure

![](logo.png)

## Requirements

* docker >= 17.12.0+
* docker-compose

## Build 

*  To Build the all necessary images regarding of your environment, it could be your machine as development or your host machine as production environment. Follow the example below; 
    * Starts building for development; 

    ```sh
    $ sh build.sh -k id_rsa -e dev
    ```
    *  Starts building for production; 

    ```sh
    $ sh build.sh -k id_rsa -e prod -d w3.avignon.inra.fr/bas_insylva/ -ip 147.100.20.44 -p 8081
    ```

## RUN 
* To able to run `Infrastructure`, please follow these stages below; 
    * Run this command 
    ```sh
    $ docker-compose --compatibility up -d
    ```
    * Run this command for stats of the container (ex: Mem & CPU usage.) 
     ```sh
    $ docker stats postgres_container
    ```

* After build stage is completed, you should configure your 'Keycloak',
    * First, please go your PgAdmin (http://$YOUR_IP_OR_LOCALHOST:5050/), then enter the credentials that located in the project root .env file. After login, make your postgresql settings and switch the 'keycloak as your primary database' and run this command as below; 

     ```sql
      update REALM set ssl_required = 'NONE' where id = 'master';
     ```
     * Second, please go your Keycloak application by following this url ((http://$YOUR_IP_OR_LOCALHOST:7000/keycloak/auth/), then enter the neccessary login credentials that located in the project root .env file, and import the `realm-export.json` it is located in the keycloak folder.

     * After the second step, please run below command to able to create admin user for the system, be aware it is very important, without this account you cannot acces to portal.

     * Finaly you can access to portal, with these credentials: 
        * username: admin@inrae.fr
        * psswd: 

       ```sh
        $ curl --location --request POST 'http://$YOUR_IP_OR_LOCALHOST:4000/user/create-system-user'
       ```

[![asciicast](https://asciinema.org/a/aoUNfjZ2okPW5WFltYSQqmrsm.svg)](https://asciinema.org/a/aoUNfjZ2okPW5WFltYSQqmrsm)

## Attention

You do not need to generate CA (pem file with openssl) or edit docker-compose.yml file unless you needed it. If you want to change those files and settings, please read the instructions as below carefully.

## Bash access to containers

To create an interactive Bash session in a container, run `docker ps` to find the container ID. Then run:

`docker exec -it <container-id> /bin/bash`

## Important settings

For production workloads, make sure the Linux setting `vm.max_map_count` is set to at least 262144. On the Open Distro for Elasticsearch Docker image, this setting is the default. To verify, start a Bash session in the container and run:

`cat /proc/sys/vm/max_map_count`

To increase this value, you have to modify the host operating system. On the RPM install, you can add this setting to the host machines `/etc/sysctl.conf` file by adding the following line:

`vm.max_map_count=262144`

Then run `sudo sysctl -p` to reload.

This value is controled when you run build.sh script. A warning message will be displayed in case of vm.max_map_count incompatible with Open Distro Elasticsearch Docker image.

The docker-compose.yml file also contains several key settings: `bootstrap.memory_lock=true, ES_JAVA_OPTS=-Xms512m -Xmx512m`, nofile 65536 and port 9600. Respectively, these settings disable memory swapping (along with memlock), set the size of the Java heap (we recommend half of system RAM), set a limit of 65536 open files for the Elasticsearch user, and allow you to access Performance Analyzer on port 9600.

## Environments

This Compose file contains the following environment variables:

* `POSTGRES_USER` the default value is **insylva_admin_pg**
* `POSTGRES_PASSWORD` the default value is **v2kGBDUaGjXK2VuPyf5R64VS**
* `PGADMIN_PORT` the default value is **5050**
* `PGADMIN_DEFAULT_EMAIL` the default value is **aytac.ozkan@inra.fr**
* `PGADMIN_DEFAULT_PASSWORD` the default value is **v2kGBDUaGjXK2VuPyf5R64VS**

## Access to postgres

* `localhost:5432`
* **Username:** insylva_admin_pg (as a default)
* **Password:** v2kGBDUaGjXK2VuPyf5R64VS (as a default)

## Access to PgAdmin

* **URL:** `http://localhost:5050`
* **Username:** aytac.ozkan@inra.fr (as a default)
* **Password:** v2kGBDUaGjXK2VuPyf5R64VS (as a default)

## Access to Portainer
* **URL:** `http://localhost:9000`
* **Username:** admin
* **Password:** on the first connexion, you'll be invited to define a password (minimum 8 characters)
* 
## Generate Certificates

Able to run well secured Elk stack instances with `OpenDistro` on docker, we have to generate some SSL certificates as below.

To generate the necessary certificates, you have to install OpenSSL on your local or host machine.

 For for example:

 On fedora : `sudo yum install openssl`

### Generate a private key

The first step in this process is to generate a private key using the `genrsa` command. As the name suggests, you should keep this file private.

Private keys must be of sufficient length to be secure, so specify 2048:

`openssl genrsa -out root-ca-key.pem 2048`

You can optionally add the `-aes256` option to encrypt the key using the AES-256 standard. This option requires a password.

### Generate a root certificate

Next, use the key to generate a self-signed certificate for the root CA (Certificate Authority):

`openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem`

* The `-x509` option specifies that you want a self-signed certificate rather than a certificate request.
* The `-sha256` option sets the hash algorithm to SHA-256. SHA-256 is the default in later versions of OpenSSL, but earlier versions might use `SHA-1`.
* Optionally, add `-days 3650` (10 years) or some other number of days to set an expiration date.

Follow the prompts to specify details for our organization (INRA). Together, these details form the distinguished name (DN) of your CA.

## Generate an admin certificate

To generate an admin certificate, first create a new key:

`openssl genrsa -out admin-key-temp.pem 2048`

Then convert that key to PKCS#8 format for use in Java using a PKCS#12-compatible algorithm (3DES):

`openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem`

Next, create a certificate signing request (CSR). This file acts as an application to a CA for a signed certificate:

`openssl req -new -key admin-key.pem -out admin.csr`

Finally, generate the certificate itself:

`openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem`

Rather than run these commands one by one above, simply run shell script file at the project root that stated with this command and complete what prompt asked.

`sh ./generate-certificates.sh`

* Country Name (2 letter code) [XX]:FR
* State or Province Name (full name) []:PACA
* Locality Name (eg, city) [Default City]:AVIGNON
* Organization Name (eg, company) [Default Company Ltd]:INRA
* Organizational Unit Name (eg, section) []:IN-SYLVA
* Common Name (eg, your name or your server's hostname) []:*.in-sylva.fr

`subject=C = FR, ST = PACA, L = AVIGNON, O = INRA, OU = INSYLVA, CN = N`

## Internal Users for Elk Stack

### internal_users.yml

This file contains any initial users that you want to add to the Security plugin’s internal user database.
The file format requires a hashed password. To generate one, run

* **insylva_password:** InSylva146544 (as a default)

```properties
    cd security/tools && java -cp "./*" com.amazon.opendistroforelasticsearch.security.tools.Hasher "-p ${password=insylva_password}"
```

``` yaml
admin:
    hash: "$2y$12$HDfDjEmrA6FjrhJ6X4qso.01PaMvWoeuCCF3S2f6ZAA6z5om92Mgq"
    reserved: true
    backend_roles:
        - "admin"
    description: "In-Sylva admin user elkstack"

kibanaserver:
    hash: "$2y$12$5If1RBIww9qUNYSmeda1b.x8UlL7z1fjhH9oLUgTwuNHFWrnjcOBu"
    reserved: true
    description: "In-Sylva kibanaserver user"

kibanaro:
    hash: "$2y$12$Ip/adRd.cfdTb7pT.i.UUOedeCWbvmQP3e7XFqSedshOWOFVYOqjO"
    reserved: false
    backend_roles:
        - "kibanauser"
        - "readall"
    attributes:
        attribute1: "value1"
        attribute2: "value2"
        attribute3: "value3"
    description: "In-Sylva kibanaro user"

logstash:
    hash: "$2y$12$HlY9kVz3a1aiEhLIza9u9uNlsfXm6WTRz1cwGWCXwGR3RyEw/sA8G"
    reserved: false
    backend_roles:
        - "logstash"
    description: "In-Sylva logstash user"

readall:
    hash: "$2y$12$7dyrvh75JXmORh4lWt5tXu.sP9djoatha04hJ1zuGTkIsgKeH3bxi"
    reserved: false
    backend_roles:
        - "readall"
    description: "In-Sylva readall user"

snapshotrestore:
    hash: "$2y$12$nAopFvn4Ni0bMOKFui6Q7eLXoRSE20XPPJEI6ffpc7vVO9uM6D9sy"
    reserved: false
    backend_roles:
        - "snapshotrestore"
    description: "In-Sylva snapshotrestore user"
```

## Validate YAML

`elasticsearch.yml` and the files in `opendistro_security/securityconfig/` are in the YAML format. A linter like YAML Lint can help verify that you don’t have any formatting errors.

### View contents of PEM certificates

You can use OpenSSL to display the content of each PEM certificate:

`openssl x509 -subject -nameopt RFC2253 -noout -in admin.pem`

Then ensure that the value matches the one in `elasticsearch.yml`.
For more complete information on a certificate:
`openssl x509 -in admin.pem -text -noout`

### NOSPC: no space left on device' while running the nodeJS in docker

`sudo docker system prune -af`


# Using the Admin CLI of Keycloak

```sh
$ $JBOSS_HOME/bin/kcadm.sh config credentials --server http://localhost:8080/keycloak/auth --realm master --user insylva_admin --password v2kGBDUaGjXK2VuPyf5R64VS
$ kcadm.sh create realms -s realm=in-sylva-2 -s enabled=true -o
$ CID=$(kcadm.sh create clients -r in-sylva-2 -s clientId=my_client -s 'redirectUris=["*"]' -i)
$ kcadm.sh get clients/$CID/installation/providers/keycloak-oidc-keycloak-json
```
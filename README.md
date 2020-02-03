# In-Sylva Infrastructure

## Requirements

* docker >= 17.12.0+
* docker-compose

* Run this command `docker-compose --compatibility up -d`
* Run this command for stats of the container (ex: Mem & CPU usage.) `docker stats postgres_container`

## Bash access to containers

To create an interactive Bash session in a container, run `docker ps` to find the container ID. Then run:

`docker exec -it <container-id> /bin/bash`

## Important settings

For production workloads, make sure the Linux setting `vm.max_map_count` is set to at least 262144. On the Open Distro for Elasticsearch Docker image, this setting is the default. To verify, start a Bash session in the container and run:

`cat /proc/sys/vm/max_map_count`

To increase this value, you have to modify the Docker image. On the RPM install, you can add this setting to the host machines `/etc/sysctl.conf` file by adding the following line:

`vm.max_map_count=262144`

Then run `sudo sysctl -p` to reload.

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
* **Username:** postgres (as a default)
* **Password:** changeme (as a default)

## Access to PgAdmin

* **URL:** `http://localhost:5050`
* **Username:** aytac.ozkan@inra.fr (as a default)
* **Password:** v2kGBDUaGjXK2VuPyf5R64VS (as a default)

## Generate Certificates

Able to run well secured Elk stack instances with `OpenDistro` on docker, we have to generate some SSL sertificates as below.

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

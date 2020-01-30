# In-Sylva Infrastructure

## Requirements:
* docker >= 17.12.0+
* docker-compose


* Run this command `docker-compose --compatibility up -d`
* Run this command for stats of the container (ex: Mem & CPU usage.) `docker stats postgres_container`

## Environments
This Compose file contains the following environment variables:

* `POSTGRES_USER` the default value is **insylva_admin_pg**
* `POSTGRES_PASSWORD` the default value is **v2kGBDUaGjXK2VuPyf5R64VS**
* `PGADMIN_PORT` the default value is **5050**
* `PGADMIN_DEFAULT_EMAIL` the default value is **aytac.ozkan@inra.fr**
* `PGADMIN_DEFAULT_PASSWORD` the default value is **v2kGBDUaGjXK2VuPyf5R64VS**

## Access to postgres: 
* `localhost:5432`
* **Username:** postgres (as a default)
* **Password:** changeme (as a default)

## Access to PgAdmin: 
* **URL:** `http://localhost:5050`
* **Username:** aytac.ozkan@inra.fr (as a default)
* **Password:** v2kGBDUaGjXK2VuPyf5R64VS (as a default)


## Generate certificates

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

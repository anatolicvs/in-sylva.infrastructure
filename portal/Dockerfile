# build environment
FROM node:latest as portal

RUN apt-get update && \
    apt-get install -y  git \
    openssh-server

RUN mkdir /var/run/sshd
EXPOSE 22 

ARG SSH_KEY
ARG SSH_KEY_PASSPHRASE
RUN chmod go-w /root

RUN mkdir -p /root/.ssh && \
    chmod 600 /root/.ssh 

RUN echo "$SSH_KEY" >> /root/.ssh/id_rsa && \
    echo "$SSH_KEY_PASSPHRASE" >> /root/.ssh/id_rsa.pub 

RUN chmod -R 600 /root/.ssh/id_rsa && \
    chmod -R 600 /root/.ssh/id_rsa.pub 

RUN ssh-keyscan -Ht rsa forgemia.inra.fr,147.100.164.13 >> ~/.ssh/known_hosts

RUN mkdir /app/ 

WORKDIR /app/

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.portal.git

RUN cd ./in-sylva.portal && yarn

WORKDIR /app/in-sylva.portal/

ENV PATH /app/in-sylva.portal/node_modules/.bin:$PATH
ENV PORT=3000
RUN yarn build

# production environment
FROM nginx:1.18.0

RUN apt-get update && apt-get install wget -y && apt-get install telnet -y

RUN apt-get install iputils-ping -y

RUN apt-get update && apt-get install nginx-extras -y

RUN apt-get install curl gnupg2 ca-certificates lsb-release -y

RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
RUN echo "deb http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

RUN apt-key fingerprint ABF5BD827BD9BF62

# RUN apt-get update && apt-get upgrade && apt-get install nginx-module-njs -y

# RUN apt-get update && apt-get install nginx-module-geoip -y

# RUN apt-get update && apt-get install nginx-module-image-filter -y
# RUN apt-get update && apt-get install nginx-module-njs -y
# RUN apt-get update && apt-get install nginx-module-perl -y 
# RUN apt-get update && apt-get install nginx-module-xslt -y

COPY --from=portal /app/in-sylva.portal/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/conf.d
COPY nginx/gzip.conf /etc/nginx/conf.d
COPY nginx/hello_world.js /etc/nginx/conf.d/hello_world.js

WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .

# Run script which initializes env vars to fs
RUN chmod +x env.sh
RUN ./env.sh

EXPOSE 3000
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
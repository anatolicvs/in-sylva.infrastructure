FROM node:latest

RUN apt-get update && \
    apt-get install -y  git \
    openssh-server

RUN mkdir /var/run/sshd
EXPOSE 22 

RUN npm install --global pm2

RUN apt-get update && apt-get install wget && apt-get install telnet -y

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

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.user.login.git

RUN cd ./in-sylva.user.login && yarn && yarn build

ENV NODE_ENV production
ENV PROCESS_TYPE web
ENV PORT 8080

ARG PM2_IN_SYLVA_GATEKEEPER_HOST
ARG IN_SYLVA_GATEKEEPER_PORT

ARG IN_SYLVA_KEYCLOAK_HOST
ARG IN_SYLVA_KEYCLOAK_PORT

ARG IN_SYLVA_SEARCH_HOST
ARG IN_SYLVA_SEARCH_PORT

ENV PM2_IN_SYLVA_GATEKEEPER_HOST=${PM2_IN_SYLVA_GATEKEEPER_HOST}
ENV IN_SYLVA_GATEKEEPER_PORT=${IN_SYLVA_GATEKEEPER_PORT}

ENV IN_SYLVA_KEYCLOAK_HOST=${IN_SYLVA_KEYCLOAK_HOST}
ENV IN_SYLVA_KEYCLOAK_PORT=${IN_SYLVA_KEYCLOAK_PORT}

ENV IN_SYLVA_SEARCH_HOST=${IN_SYLVA_SEARCH_HOST}
ENV IN_SYLVA_SEARCH_PORT=${IN_SYLVA_SEARCH_PORT}

EXPOSE 8080

WORKDIR /app/in-sylva.user.login/

CMD [ "pm2-runtime", "npm","--", "start" ]
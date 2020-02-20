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

RUN cd ./in-sylva.portal && npm install

WORKDIR /app/in-sylva.portal/

ENV PATH /app/in-sylva.portal/node_modules/.bin:$PATH
ENV PORT=3000
RUN yarn build

# production environment
FROM nginx:latest

ARG REACT_APP_IN_SYLVA_GATEKEEPER_HOST
ARG REACT_APP_IN_SYLVA_GATEKEEPER_PORT
ARG REACT_APP_IN_SYLVA_SOURCE_MANAGER_HOST
ARG REACT_APP_IN_SYLVA_SOURCE_MANAGER_PORT
ARG REACT_APP_IN_SYLVA_KEYCLOAK_HOST
ARG REACT_APP_IN_SYLVA_KEYCLOAK_PORT

ENV REACT_APP_IN_SYLVA_GATEKEEPER_HOST=$REACT_APP_IN_SYLVA_GATEKEEPER_HOST
ENV REACT_APP_IN_SYLVA_GATEKEEPER_PORT=$REACT_APP_IN_SYLVA_GATEKEEPER_PORT
ENV REACT_APP_IN_SYLVA_SOURCE_MANAGER_HOST=$REACT_APP_IN_SYLVA_SOURCE_MANAGER_HOST
ENV REACT_APP_IN_SYLVA_SOURCE_MANAGER_PORT=$REACT_APP_IN_SYLVA_SOURCE_MANAGER_PORT
ENV REACT_APP_IN_SYLVA_KEYCLOAK_HOST=$REACT_APP_IN_SYLVA_KEYCLOAK_HOST
ENV REACT_APP_IN_SYLVA_KEYCLOAK_PORT=$REACT_APP_IN_SYLVA_KEYCLOAK_PORT

COPY --from=portal /app/in-sylva.portal/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/conf.d
COPY nginx/gzip.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .

# Run script which initializes env vars to fs
RUN chmod +x env.sh
RUN ./env.sh

EXPOSE 3000
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
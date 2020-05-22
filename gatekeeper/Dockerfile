FROM centos:latest

RUN yum update -y && yum install -y openssh-server wget telnet openssl openssh-clients git && yum clean all

# LTS version
ENV NODE_VERSION 12.16.3 

# SHELL ["/bin/bash", "--login", "-i", "-c"]
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# RUN source /root/.bashrc && nvm install $NODE_VERSION
# SHELL ["/bin/bash", "--login", "-c"]

RUN dnf module enable nodejs:12 -y

RUN dnf install nodejs -y

RUN npm install --global pm2

RUN npm install -g yarn

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

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.gatekeeper.git

RUN cd ./in-sylva.gatekeeper && yarn

WORKDIR /app/in-sylva.gatekeeper/

CMD [ "pm2-runtime","--name","in-sylva.gatekeeper", "yarn start:prod"]

# CMD [ "npm", "run", "start:prod" ]

# FROM node:latest

# RUN apt-get update && \
#     apt-get install -y  git \
#     openssh-server

# RUN apt-get install wget && apt-get install telnet -y
# RUN npm install --global pm2

# RUN mkdir /var/run/sshd
# EXPOSE 22 
# ARG SSH_KEY
# ARG SSH_KEY_PASSPHRASE
# RUN chmod go-w /root

# RUN mkdir -p /root/.ssh && \
#     chmod 600 /root/.ssh 

# RUN echo "$SSH_KEY" >> /root/.ssh/id_rsa && \
#     echo "$SSH_KEY_PASSPHRASE" >> /root/.ssh/id_rsa.pub 

# RUN chmod -R 600 /root/.ssh/id_rsa && \
#     chmod -R 600 /root/.ssh/id_rsa.pub 

# RUN ssh-keyscan -Ht rsa forgemia.inra.fr,147.100.164.13 >> ~/.ssh/known_hosts

# RUN mkdir /app/ 

# WORKDIR /app/

# RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.gatekeeper.git

# RUN cd ./in-sylva.gatekeeper && yarn

# WORKDIR /app/in-sylva.gatekeeper/

# CMD [ "pm2-runtime","--name","in-sylva.gatekeeper", "yarn start:prod"]
# CMD [ "npm", "run", "start:prod" ]

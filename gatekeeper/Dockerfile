FROM alpine as intermediate
LABEL stage=intermediate

RUN apk update && \
    apk add --update git && \
    apk add --update openssh

EXPOSE 22

ARG SSH_KEY
ARG SSH_KEY_PASSPHRASE

RUN chmod go-w /root
# 1. Create the SSH directory.
# 2. Set the required permissions.
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh 

# 1. Populate the private key file.
# 2. Set the required permissions.
RUN chmod -R 600 /root/.ssh/ && \ 
    echo "$SSH_KEY" > /root/.ssh/id_rsa_insylva_docker && \
    echo "$SSH_KEY_PASSPHRASE" > /root/.ssh/id_rsa_insylva_docker.pub 

# 1. Add github to our list of known hosts for ssh.
RUN ssh-keyscan -t rsa forgemia.inra.fr >> ~/.ssh/known_hosts

RUN mkdir /home/app/ 

WORKDIR /home/app/

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.gatekeeper.git

FROM node:latest

RUN mkdir /home/app/ 

WORKDIR /home/app/

COPY --from=intermediate /home/app /home/app

RUN cd ./in-sylva.gatekeeper && npm install

ENV NODE_ENV production
ENV PROCESS_TYPE web
ENV PORT 3000

EXPOSE 5000


CMD ["npm", "run", "start:prod"]

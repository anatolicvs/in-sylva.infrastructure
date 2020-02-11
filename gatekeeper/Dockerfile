FROM node:latest

ARG SSH_KEY
ARG SSH_KEY_PASSPHRASE
ARG KNOWN_HOSTS

RUN apt-get update && \
    apt-get install -y \
    git \
    openssh-server

RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan forgemia.inra.fr,147.100.164.13 > /root/.ssh/known_hosts

RUN echo "${SSH_KEY}" > /root/.ssh/id_ed25519 && \
    echo "${SSH_KEY_PASSPHRASE}" > /root/.ssh/id_ed25519.pub && \
    chmod 600 /root/.ssh/id_ed25519 && \
    chmod 600 /root/.ssh/id_ed25519.pub

RUN mkdir /home/app/ 

WORKDIR /home/app/

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.gatekeeper.git

RUN cd ./in-sylva.gatekeeper && npm install

ENV NODE_ENV production
ENV PROCESS_TYPE web
ENV PORT 3000

EXPOSE 5000

CMD ["npm", "run", "start:prod"]

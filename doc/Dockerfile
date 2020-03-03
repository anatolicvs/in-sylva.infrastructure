FROM node:latest

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

RUN git clone git@forgemia.inra.fr:in-sylva-development/in-sylva.doc.git

RUN cd ./in-sylva.doc/website && yarn

EXPOSE 3000 35729

WORKDIR /app/in-sylva.doc/website/

CMD ["yarn", "start"]

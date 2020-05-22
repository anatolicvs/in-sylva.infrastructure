FROM centos:latest

ENV KEYCLOAK_VERSION 10.0.1
ENV JDBC_POSTGRES_VERSION 42.2.5
ENV JDBC_MYSQL_VERSION 8.0.19
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 7.4.1.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

ARG GIT_REPO
ARG GIT_BRANCH
ARG KEYCLOAK_DIST=https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz

RUN yum update -y && yum install -y gzip hostname java-11-openjdk-headless openssl tar which && yum clean all

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

RUN mkdir /home/realms
COPY realm-export.json /home/realms

RUN sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN sed -i -e 's/\/auth/\/keycloak\/auth"/' $JBOSS_HOME/welcome-content/index.html

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]

# RUN $JBOSS_HOME/bin/kcadm.sh config credentials --server http://localhost:8080/keycloak/auth --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD

FROM postgres:12.3-alpine

COPY create-multiple-postgresql-databases.sh /docker-entrypoint-initdb.d/
# RUN chown postgres:postgres /docker-entrypoint-initdb.d/

EXPOSE 5432
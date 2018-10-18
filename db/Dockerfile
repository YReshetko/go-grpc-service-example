FROM postgres:alpine

COPY ./db/init-db.sql /docker-entrypoint-initdb.d/init-db.sql
EXPOSE 5432

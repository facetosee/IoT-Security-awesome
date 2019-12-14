FROM postgres

ENV POSTGRES_PASSWORD "pgpass"
ENV DBPASS "dbpass"

# add dbinit to /docker-entrypoint-initdb.d
ADD dbinit.sh /docker-entrypoint-initdb.d/dbinit.sh

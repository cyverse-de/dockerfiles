FROM postgres:12.4

COPY stretch-backports.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get install -y openjdk-11-jre-headless netcat \
  && rm -rf /var/lib/apt/lists/*

COPY database.tar.gz /database.tar.gz
COPY metadata-db.tar.gz /metadata-db.tar.gz
COPY notification-db.tar.gz /notification-db.tar.gz
COPY permissions-db.tar.gz /permissions-db.tar.gz
COPY facepalm-standalone.jar /facepalm-standalone.jar

COPY setup-pg-hbaconf.sh /docker-entrypoint-initdb.d/
COPY setup-dev-database.sh /bin/setup-dev-database.sh
COPY update-dev-database.sh /bin/update-dev-database.sh
COPY setup-grouper-database.sh /bin/setup-grouper-database.sh
COPY wait-for-port.sh /bin/wait-for-port.sh
COPY pgpass /root/.pgpass
RUN chmod 0600 /root/.pgpass
RUN mkdir /data
ENV POSTGRES_PASSWORD=notprod POSTGRES_USER=de PGDATA=/data
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]

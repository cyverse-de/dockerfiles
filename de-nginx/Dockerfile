FROM nginx
MAINTAINER Sarah Roberts <sarahr@cyverse.org>

COPY cyverse-ca.crt /usr/share/ca-certificates/cyverse/

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    cat $(find /usr/share/ca-certificates -mindepth 2 -name '*.crt') > /usr/share/ca-certificates/all.crt

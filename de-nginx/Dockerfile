FROM nginx
MAINTAINER Sarah Roberts <sarahr@cyverse.org>

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    cat $(find /usr/share/ca-certificates -mindepth 2 -name '*.crt') > /usr/share/ca-certificates/all.crt

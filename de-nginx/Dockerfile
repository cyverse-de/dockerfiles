FROM nginx:perl
MAINTAINER Sarah Roberts <sarahr@cyverse.org>

COPY prod.crt /usr/share/ca-certificates/prod.crt
COPY test.crt /usr/share/ca-certificates/test.crt

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    cat $(find /usr/share/ca-certificates -mindepth 2 -name '*.crt') > /usr/share/ca-certificates/all.crt

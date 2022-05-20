FROM alpine:3.15

RUN apk add --no-cache curl jq bash

COPY configurator.sh /usr/bin/configurator.sh

ENTRYPOINT ["configurator.sh"]

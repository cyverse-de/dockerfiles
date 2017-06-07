# Dockerfile for https://github.com/jupyterhub/configurable-http-proxy.

FROM mhart/alpine-node:8.0.0

LABEL maintainer "John Wregglesworth <wregglej@cyverse.org>"

RUN npm install -g configurable-http-proxy

ENV CONFIGPROXY_AUTH_TOKEN=unsafe-default

EXPOSE 8000 8001

ENTRYPOINT ["configurable-http-proxy"]

CMD ["--api-ip", "0.0.0.0"]

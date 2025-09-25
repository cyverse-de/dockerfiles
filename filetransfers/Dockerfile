FROM cyverse/gocmd:latest As gocmd
FROM debian:stable-slim
COPY --from=gocmd /usr/bin/gocmd /usr/bin/gocmd

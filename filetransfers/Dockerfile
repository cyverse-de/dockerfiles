FROM ghcr.io/awesome-containers/static-coreutils:latest AS coreutils
FROM harbor.cyverse.org/de/gocmd:latest
COPY --from=coreutils /bin/tee /bin/tee


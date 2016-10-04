#!/bin/bash

# A usage message.
usage=<<EOF
Usage: create-image.sh [-r|-R]

Options:
    -r - Automatically retrieve database tarballs and facepalm uberjar [default]
    -R - Do not retrieve database tarballs and facepalm uberjar
EOF

# Parse the command-line options.
retrieve=true
while getopts :rR opt; do
    case $opt in
        r)
            retrieve=true
            ;;
        R)
            retrieve=false
            ;;
        \?)
            echo $usage
            exit 1
            ;;
    esac
done

set -e
set -x

if [ "$retrieve" = true ]; then
    docker pull discoenv/facepalm:dev
    docker create --name fp discoenv/facepalm:dev
    docker cp fp:/usr/src/app/database.tar.gz .
    docker cp fp:/usr/src/app/metadata-db.tar.gz .
    docker cp fp:/usr/src/app/notification-db.tar.gz .
    docker cp fp:/usr/src/app/permissions-db.tar.gz .
    docker cp fp:/usr/src/app/facepalm-standalone.jar .
    docker rm -fv fp
fi

if [ $(docker ps | grep '\sdedb$' | wc -l) -gt 0 ]; then
    docker kill dedb
fi

if [ $(docker ps -a | grep '\sdedb$' | wc -l) -gt 0 ]; then
    docker rm -v dedb
fi

docker build --rm -t discoenv/de-db-loader:dev .
docker run -d --name dedb discoenv/de-db-loader:dev
docker exec dedb wait-for-port.sh -p 5432
docker exec dedb setup-dev-database.sh
docker exec dedb setup-grouper-database.sh
docker commit dedb discoenv/unittest-dedb:dev
docker kill dedb
docker rm -v dedb

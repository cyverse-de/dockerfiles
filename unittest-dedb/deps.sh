#!/bin/bash

# A usage message.
usage=<<EOF
Usage: create-image.sh [-r|-R|-g|-G]

Options:
    -r - Automatically retrieve database tarballs and facepalm uberjar [default]
    -R - Do not retrieve database tarballs and facepalm uberjar
    -g - Automatically clone the database repos and build the tarballs
    -G - Do not clone the database repos and build the tarballs [default]
EOF

BUILD_IMAGE=${IMAGE:-discoenv/unittest-dedb:dev}

# Parse the command-line options.
retrieve=true
builddb=false
while getopts :rRgG opt; do
    case $opt in
        r)
            retrieve=true
            ;;
        R)
            retrieve=false
            ;;
        g)
            builddb=true
            ;;
        G)
            builddb=false
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

if [ "$retrieve" = false -a "$builddb" = true ]; then
    docker pull discoenv/facepalm:dev
    docker create --name fp discoenv/facepalm:dev
    docker cp fp:/usr/src/app/facepalm-standalone.jar .
    docker rm -fv fp

    if [ -d "./de-db" ]; then
        rm -rf ./de-db
    fi
    git clone git@github.com:cyverse-de/de-db.git

    if [ -d "./metadata-db" ]; then
        rm -rf ./metadata-db
    fi
    git clone git@github.com:cyverse-de/metadata-db.git

    if [ -d "./permissions-db" ]; then
        rm -rf ./permissions-db
    fi
    git clone git@github.com:cyverse-de/permissions-db.git

    if [ -d "./notifications-db" ]; then
        rm -rf ./notifications-db
    fi
    git clone git@github.com:cyverse-de/notifications-db.git

    cwd=$(pwd)
    cd $cwd/de-db && ./build.sh && cp database.tar.gz $cwd
    cd $cwd/metadata-db && ./build.sh && cp metadata-db.tar.gz $cwd
    cd $cwd/permissions-db && ./build.sh && cp permissions-db.tar.gz $cwd
    cd $cwd/notifications-db && ./build.sh && cp notification-db.tar.gz $cwd
    cd $cwd
fi
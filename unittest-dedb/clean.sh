#!/bin/sh

if [ -d "./de-db" ]; then
    rm -rf ./de-db
fi

if [ -f "./database.tar.gz" ]; then
    rm -f ./database.tar.gz
fi

if [ -d "./metadata-db" ]; then
    rm -rf ./metadata-db
fi

if [ -f "./metadata-db.tar.gz" ]; then
    rm -f ./metadata-db.tar.gz
fi

if [ -d "./permissions-db" ]; then
    rm -rf ./permissions-db
fi

if [ -f "./permissions-db.tar.gz" ]; then
    rm -f ./permissions-db.tar.gz
fi

if [ -d "./notifications-db" ]; then
    rm -rf ./notifications-db
fi

if [ -f "./notification-db.tar.gz" ]; then
    rm -f ./notification-db.tar.gz
fi

if [ -f "./facepalm-standalone.jar" ]; then
    rm -rf ./facepalm-standalone.jar
fi



    
#!/bin/sh

./clean.sh
./deps.sh -R -g
skaffold dev


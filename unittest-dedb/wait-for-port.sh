#!/bin/bash

# A usage message.
usage=<<EOF
Usage: wait-for-port.sh [-p PORT]

Options:
    -p PORT - specify the port to connect to (default: 5432).
EOF

# Parse the command-line options.
port=5432
while getopts :p: opt; do
    case $opt in
        p)
            port="$OPTARG"
            ;;
        \?)
            echo $usage
            exit 1
            ;;
    esac
done

for i in {1..10}; do
    if nc -q 1 localhost "$port"; then
        exit 0
    fi
    sleep 10
done

exit 1

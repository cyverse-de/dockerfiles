#!/bin/bash

set -e

# The K8s namespace to search for resources.
NAMESPACE=${NAMESPACE:-prod}

# The host and port to use for hitting the k8s API.
HOST_PORT=${HOST_PORT:-'localhost:8001'}

# The delimiter to use when separating values in the output.
DELIMITER=${DELIMITER:-','}

# The label to use to filter pods.
LABEL_SELECTOR=${LABEL_SELECTOR:-'app.kubernetes.io/name'}

# The value associated with the label to use when filtering pods
SELECTOR_VALUE=${SELECTOR_VALUE:-'nats'}

# The name of the env variable to use in the dotenv file.
ENV_VAR=${ENV_VAR:-'DISCOENV_NATS_CLUSTER'}

# The file path to the dotenv file.
DOTENV_FILEPATH=${DOTENV_FILEPATH:-'/etc/cyverse/de/env/service.env'}

# The directory containing the dotenv file. Calculated from the filepath.
dotenv_dir=$(dirname $DOTENV_FILEPATH)

# The full, unencoded selector to use when filtering pods.
full_selector=$LABEL_SELECTOR=$SELECTOR_VALUE

# The URL encoded version of full_selector.
encoded_selector=$(echo -n "$full_selector" | jq -sRr @uri)

# The full k8s API URL to GET when looking up a list of pods.
reqURL="http://$HOST_PORT/api/v1/namespaces/$NAMESPACE/pods?labelSelector=$encoded_selector"

# The names of the pods, separated by delimiter.
output=$(curl --silent $reqURL | jq -r '.items[].metadata.name' | sed -e 's/^/tls:\/\//' | paste -s -d, -)

# Make sure the directory that will contain the dotenv file actually exists.
if [ ! -d $dotenv_dir ]; then 
    mkdir -p $dotenv_dir
fi

# Append the env var setting to the end of the dotenv file.
echo "$ENV_VAR=\"$output\"" >> $DOTENV_FILEPATH



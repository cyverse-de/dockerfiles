#!/bin/bash

set -e

# The K8s namespace to search for resources.
#NAMESPACE=${NAMESPACE:-prod}

# THE URL to the api server
#APISERVER=${APISERVER:-'https://kubernetes.default.svc'}

# The path to the service account token.
#SERVICEACCOUNT=${SERVICEACCOUNT:-'/var/run/secrets/kubernetes.io/serviceaccount'}

# The service accounts bearer token
#token=$(cat ${SERVICEACCOUNT}/token)

# The ca certificate
#cacert=${SERVICEACCOUNT}/ca.crt

# The delimiter to use when separating values in the output.
#DELIMITER=${DELIMITER:-','}

# The label to use to filter pods.
#LABEL_SELECTOR=${LABEL_SELECTOR:-'app.kubernetes.io/name'}

# The value associated with the label to use when filtering pods
#SELECTOR_VALUE=${SELECTOR_VALUE:-'nats'}

# The name of the env variable to use in the dotenv file.
ENV_VAR=${ENV_VAR:-'DISCOENV_NATS_CLUSTER'}

# The file path to the dotenv file.
DOTENV_FILEPATH=${DOTENV_FILEPATH:-'/etc/cyverse/de/env/service.env'}

# The directory containing the dotenv file. Calculated from the filepath.
dotenv_dir=$(dirname $DOTENV_FILEPATH)

# The full, unencoded selector to use when filtering pods.
#full_selector=$LABEL_SELECTOR=$SELECTOR_VALUE

# The URL encoded version of full_selector.
#encoded_selector=$(echo -n "$full_selector" | jq -sRr @uri)

# The full k8s API URL to GET when looking up a list of pods.
#reqURL="${APISERVER}/api/v1/namespaces/${NAMESPACE}/pods?labelSelector=$encoded_selector"

# The names of the pods, separated by delimiter.
#output=$(curl --cacert ${cacert} --header "Authorization: Bearer ${token}" --silent $reqURL | jq -r '.items[].metadata.name' | sed -e 's/^/nats:\/\//' | sed -e 's/$/\.nats/' | paste -s -d, -)

output="nats://nats-0.nats,nats://nats-1.nats,nats://nats-2.nats,nats://nats-3.nats"

# Make sure the directory that will contain the dotenv file actually exists.
if [ ! -d $dotenv_dir ]; then 
    mkdir -p $dotenv_dir
fi

# Append the env var setting to the end of the dotenv file.
echo "$ENV_VAR=\"$output\"" >> $DOTENV_FILEPATH



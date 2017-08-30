#!/bin/sh

set -e

# The Consul address must be specified.
if [[ -z "$CONSUL_ADDR" ]]; then
    echo "The environment variable, CONSUL_ADDR, must be defined." 1>&2
    exit 1
fi

# The Consul token must be specified.
if [[ -z "$CONSUL_TOKEN" ]]; then
    echo "The environment variable, CONSUL_TOKEN, must be defined." 1>&2
    exit 1
fi

# The DE environment must be specified.
if [[ -z "$DE_ENV" ]]; then
    echo "The environment variable, DE_ENV, must be defined." 1>&2
    exit 1
fi

# Generate the configuration files.
consul-template -once -consul "$CONSUL_ADDR" -config "$WEBAPPS_HOME/consul.hcl"

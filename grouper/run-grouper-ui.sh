#!/bin/sh

set -e

# Generate the configuration files.
generate-configs.sh

# Run the grouper UI.
exec grouper-ui $JAVA_OPTS -jar /opt/war-runner/war-runner.jar \
     --port=80 \
     --context-path=/grouper \
     --war-file="$WEBAPPS_HOME/grouper" \
     --realm-name="Grouper Application" \
     --realm-file="$WEBAPPS_HOME/realm.properties"

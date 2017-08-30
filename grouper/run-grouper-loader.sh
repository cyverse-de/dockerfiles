#!/bin/sh

set -e

# Generate the configuration files.
generate-configs.sh

# Run the grouper UI.
exec gsh -loader

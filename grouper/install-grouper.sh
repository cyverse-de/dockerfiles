#!/bin/sh

set -e

source $(dirname $0)/install-utils.sh

# Install some prerequisites.
install_curl
create_tarball_directory
download_grouper
install_ant

# Install Grouper.
create_grouper_installation_directories
install_grouper_api
install_grouper_ui
install_grouper_web_services

# Clean up.
cleanup

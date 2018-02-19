#!/bin/sh

set -e

install_curl() {
    if [[ -f /etc/alpine-release ]]; then
        apk add --update curl
    else
        apt-get update
        apt-get install -y curl
    fi
}

create_tarball_directory() {
    mkdir -p /tmp/tarballs
    cd /tmp/tarballs
}

download_grouper() {
    curl -fSL "$GROUPER_BASE_URL/$GROUPER_API_TGZ" -o grouper-api.tar.gz
    curl -fSL "$GROUPER_BASE_URL/$GROUPER_UI_TGZ" -o grouper-ui.tar.gz
    curl -fSL "$GROUPER_BASE_URL/$GROUPER_WS_TGZ" -o grouper-ws.tar.gz
}

install_ant() {
    if [[ -f /etc/alpine-release ]]; then
        apk add --update apache-ant
    else
        apt-get update
        apt-get install -y ant
    fi
}

create_grouper_installation_directories() {
    mkdir -p "$GROUPER_BASE" "$GROUPER_LOGS" "$GROUPER_CONF" "$GROUPER_TEMP"
}

grouper_installer_properties_api() {
    cat <<EOF
grouperInstaller.autorun.useDefaultsAsMuchAsAvailable = true
grouperInstaller.autorun.actionEgInstallUpgradePatch = patch
grouperInstaller.autorun.tarballDirectory = /tmp/tarballs
grouperInstaller.autorun.appToUpgrade = api
grouperInstaller.autorun.grouperWhereInstalled = $GROUPER_HOME
grouperInstaller.autorun.patchAction = install
grouper.version = $GROUPER_VERSION
download.server.url = http://software.internet2.edu/grouper
EOF
}

install_grouper_api() {

    # Extract the Grouper API binary.
    cd "$GROUPER_BASE"
    tar -xzvf /tmp/tarballs/grouper-api.tar.gz
    mv "grouper.apiBinary-$GROUPER_VERSION" "$GROUPER_HOME"

    # Copy the custom configuration files to the configuration directory.
    mv /tmp/configs/api/ehcache.xml "$GROUPER_HOME/conf/"
    mv /tmp/configs/api/grouper.properties "$GROUPER_HOME/conf/"
    mv /tmp/configs/api/grouper.hibernate.properties "$GROUPER_HOME/conf/"
    mv /tmp/configs/api/grouper-loader.properties "$GROUPER_HOME/conf/"
    mv /tmp/configs/api/subject.properties "$GROUPER_HOME/conf"
    mv /tmp/configs/api/log4j.properties "$GROUPER_HOME/conf"

    # Add the BouncyCastle provider JAR file into the lib directory.
    curl -fSL "$BCPROV_BASE/$BCPROV_JAR" -o "$GROUPER_HOME/lib/grouper/$BCPROV_JAR"

    # Download the Grouper installer.
    mkdir -p /tmp/patch
    cd /tmp/patch
    curl -fSL "$GROUPER_BASE_URL/$GROUPER_INS_JAR" -o "$GROUPER_INS_JAR"

    # Patch the Grouper API.
    grouper_installer_properties_api > grouper.installer.properties
    java -cp .:$GROUPER_INS_JAR edu.internet2.middleware.grouperInstaller.GrouperInstaller
    rm grouper.installer.properties
}

grouper_installer_properties_ui() {
    cat <<EOF
grouperInstaller.autorun.useDefaultsAsMuchAsAvailable = true
grouperInstaller.autorun.actionEgInstallUpgradePatch = patch
grouperInstaller.autorun.tarballDirectory = /tmp/tarballs
grouperInstaller.autorun.appToUpgrade = ui
grouperInstaller.autorun.grouperWhereInstalled = $WEBAPPS_HOME/grouper
grouperInstaller.autorun.patchAction = install
grouper.version = $GROUPER_VERSION
download.server.url = http://software.internet2.edu/grouper
EOF
}

install_grouper_ui() {

    # Extract the Grouper UI.
    cd "$GROUPER_BASE"
    tar -xzvf /tmp/tarballs/grouper-ui.tar.gz
    mv "grouper.ui-$GROUPER_VERSION" "$GROUPER_UI_HOME"

    # Build the Grouper UI.
    mv /tmp/configs/ui/build.properties "$GROUPER_UI_HOME"
    cd "$GROUPER_UI_HOME"
    ant war

    # Copy the WAR file to the webapps directory and expand it.
    cp dist/grouper.war "$WEBAPPS_HOME"
    mkdir "$WEBAPPS_HOME/grouper"
    cd "$WEBAPPS_HOME/grouper"
    jar xvf ../grouper.war

    # Clean up the directory used to build the Grouper UI.
    cd "$GROUPER_BASE"
    rm -rf "$GROUPER_UI_HOME"

    # Patch the Grouper UI.
    cd /tmp/patch
    grouper_installer_properties_ui > grouper.installer.properties
    java -cp .:$GROUPER_INS_JAR edu.internet2.middleware.grouperInstaller.GrouperInstaller
    rm grouper.installer.properties
}

grouper_installer_properties_ws() {
    cat <<EOF
grouperInstaller.autorun.useDefaultsAsMuchAsAvailable = true
grouperInstaller.autorun.actionEgInstallUpgradePatch = patch
grouperInstaller.autorun.tarballDirectory = /tmp/tarballs
grouperInstaller.autorun.appToUpgrade = ws
grouperInstaller.autorun.grouperWhereInstalled = $WEBAPPS_HOME/grouper-ws
grouperInstaller.autorun.patchAction = install
grouper.version = $GROUPER_VERSION
download.server.url = http://software.internet2.edu/grouper
EOF
}

install_grouper_web_services() {

    # Extract the Grouper web services.
    cd "$GROUPER_BASE"
    tar -xzvf /tmp/tarballs/grouper-ws.tar.gz
    mv "grouper.ws-$GROUPER_VERSION" "$GROUPER_WS_HOME"

    # Build the Grouper web services.
    mv /tmp/configs/ws/build.properties "$GROUPER_WS_HOME/grouper-ws/"
    mv /tmp/configs/ws/grouper-ws.properties "$GROUPER_WS_HOME/grouper-ws/conf/"
    cd "$GROUPER_WS_HOME/grouper-ws"
    ant dist

    # Copy the WAR file to the webapps directory and expand it.
    cp build/dist/grouper-ws.war "$WEBAPPS_HOME"
    mkdir "$WEBAPPS_HOME/grouper-ws"
    cd "$WEBAPPS_HOME/grouper-ws"
    jar xvf ../grouper-ws.war

    # Clean up the directory used to build the Grouper web services.
    cd "$GROUPER_BASE"
    rm -rf "$GROUPER_WS_HOME"

    # Patch the Grouper web services.
    cd /tmp/patch
    grouper_installer_properties_ws > grouper.installer.properties
    java -cp .:$GROUPER_INS_JAR edu.internet2.middleware.grouperInstaller.GrouperInstaller
    rm grouper.installer.properties
}

cleanup() {
    if [[ -f /etc/alpine-release ]]; then
        apk del curl
        rm -rf /var/cache/apk/*
    else
        apt-get remove -y curl
    fi
    rm -rf /tmp/configs
    rm -rf /tmp/patch
    rm -rf /tmp/tarballs
}

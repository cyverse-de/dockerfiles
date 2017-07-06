#!/bin/sh

# Install curl.
apk add --update curl

# Install the unlimited strength Java cryptography extensions.
mkdir -p /tmp/jce
curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce/jce.zip \
    http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip
unzip -d /tmp/jce -o /tmp/jce/jce.zip
cp /tmp/jce/UnlimitedJCEPolicy/*.jar /opt/jdk/jre/lib/security/
rm -rf /tmp/jce

# Install GPG and add the keys we'll need for package validation.
apk add gnupg
curl -fSL https://www.apache.org/dist/tomcat/tomcat-7/KEYS -o tomcat-keys
curl -fSL https://www.apache.org/dist/ant/KEYS -o ant-keys
gpg --import tomcat-keys
gpg --import ant-keys
rm -f tomcat-keys ant-keys

# Create a temporary directory for the files that we download.
mkdir -p /tmp/tarballs
cd /tmp/tarballs

# Download and verify the Apache Ant distribution.
curl -fSL "$ANT_URL" -o apache-ant.tar.gz
curl -fSL "$ANT_URL.asc" -o apache-ant.tar.gz.asc
gpg --verify apache-ant.tar.gz.asc

# Download and verify the Apache Tomcat distribution.
curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz
curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc
gpg --verify tomcat.tar.gz.asc

# Download the Grouper distribution files.
curl -fSL "$GROUPER_BASE_URL/$GROUPER_API_TGZ" -o grouper-api.tar.gz
curl -fSL "$GROUPER_BASE_URL/$GROUPER_UI_TGZ" -o grouper-ui.tar.gz
curl -fSL "$GROUPER_BASE_URL/$GROUPER_WS_TGZ" -o grouper-ws.tar.gz

# Install Apache Ant.
cd /opt
tar -xzvf /tmp/tarballs/apache-ant.tar.gz
mv "apache-ant-$ANT_VERSION" "$ANT_HOME"

# Install Apache Tomcat.
cd /opt
tar -xzvf /tmp/tarballs/tomcat.tar.gz
mv "apache-tomcat-$TOMCAT_VERSION" "$CATALINA_HOME"
cd "$CATALINA_HOME"
rm bin/*.bat
mkdir -p "$TOMCAT_CONF"
mv "$CATALINA_HOME/conf/server.xml" "$TOMCAT_CONF/server.xml"
ln -s "$TOMCAT_CONF/server.xml" "$CATALINA_HOME/conf/server.xml"
mv "$CATALINA_HOME/conf/tomcat-users.xml" "$TOMCAT_CONF/tomcat-users.xml"
ln -s "$TOMCAT_CONF/tomcat-users.xml" "$CATALINA_HOME/conf/tomcat-users.xml"
rm -f "$CATALINA_HOME/bin/setenv.sh"
touch "$TOMCAT_CONF/setenv.sh"
ln -s "$TOMCAT_CONF/setenv.sh" "$CATALINA_HOME/bin/setenv.sh"

# Create the Grouper installation directories.
mkdir -p "$GROUPER_BASE" "$GROUPER_LOGS" "$GROUPER_CONF" "$GROUPER_TEMP"

# Extract the Grouper API binary.
cd "$GROUPER_BASE"
tar -xzvf /tmp/tarballs/grouper-api.tar.gz
mv "grouper.apiBinary-$GROUPER_VERSION" "$GROUPER_HOME"
mv /tmp/configs/api/ehcache.xml "$GROUPER_HOME/conf/"
mv /tmp/configs/api/grouper.properties "$GROUPER_HOME/conf/"
mv /tmp/configs/api/grouper.hibernate.properties "$GROUPER_HOME/conf/"
mv /tmp/configs/api/grouper-loader.properties "$GROUPER_HOME/conf/"
mv /tmp/configs/api/subject.properties "$GROUPER_HOME/conf"
mv /tmp/configs/api/log4j.properties "$GROUPER_HOME/conf"
curl -fSL "$BCPROV_BASE/$BCPROV_JAR" -o "$GROUPER_HOME/lib/grouper/$BCPROV_JAR"

# Extract the Grouper UI.
cd "$GROUPER_BASE"
tar -xzvf /tmp/tarballs/grouper-ui.tar.gz
mv "grouper.ui-$GROUPER_VERSION" "$GROUPER_UI_HOME"
mv /tmp/configs/ui/build.properties "$GROUPER_UI_HOME"
cd "$GROUPER_UI_HOME"
ant war
cp dist/grouper.war "$CATALINA_HOME/webapps"
cd "$GROUPER_BASE"
rm -rf "$GROUPER_UI_HOME"

# Etract the Grouper web services.
cd "$GROUPER_BASE"
tar -xzvf /tmp/tarballs/grouper-ws.tar.gz
mv "grouper.ws-$GROUPER_VERSION" "$GROUPER_WS_HOME"
mv /tmp/configs/ws/build.properties "$GROUPER_WS_HOME/grouper-ws/"
mv /tmp/configs/ws/grouper-ws.properties "$GROUPER_WS_HOME/grouper-ws/conf/"
cd "$GROUPER_WS_HOME/grouper-ws"
ant dist
cp build/dist/grouper-ws.war "$CATALINA_HOME/webapps"
cd "$GROUPER_BASE"
rm -rf "$GROUPER_WS_HOME"

# Clean up.
apk del gnupg
apk del curl
rm -rf /var/cache/apk/*
rm -rf /tmp/configs
rm -rf /tmp/tarballs

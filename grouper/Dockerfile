FROM jeanblanchard/java:jdk-7
MAINTAINER Dennis Roberts <dennis@cyverse.org>
ARG git_commit=unknown
LABEL org.iplantc.de.grouper.git-ref="$git_commit"

# Copy the configuration files to temporary locations.
COPY configs /tmp/configs

# Environment variables for ant.
ENV ANT_HOME /opt/apache-ant
ENV PATH $PATH:$ANT_HOME/bin
ENV ANT_BASE https://www.apache.org/dist/ant/binaries
ENV ANT_VERSION 1.9.9
ENV ANT_URL $ANT_BASE/apache-ant-$ANT_VERSION-bin.tar.gz

# Environment variables for tomcat.
ENV CATALINA_HOME /opt/tomcat
ENV TOMCAT_CONF /etc/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.65
ENV TOMCAT_BASE https://archive.apache.org/dist/tomcat
ENV TOMCAT_TGZ apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV TOMCAT_TGZ_URL $TOMCAT_BASE/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/$TOMCAT_TGZ

# Grouper environment variables.
ENV GROUPER_VERSION 2.3.0
ENV GROUPER_BASE_URL http://software.internet2.edu/grouper/release/$GROUPER_VERSION
ENV GROUPER_API_TGZ grouper.apiBinary-$GROUPER_VERSION.tar.gz
ENV GROUPER_UI_TGZ grouper.ui-$GROUPER_VERSION.tar.gz
ENV GROUPER_WS_TGZ grouper.ws-$GROUPER_VERSION.tar.gz
ENV GROUPER_BASE /opt/grouper
ENV GROUPER_LOGS /var/log/grouper
ENV GROUPER_CONF /etc/grouper
ENV GROUPER_TEMP /tmp/grouper
ENV GROUPER_HOME $GROUPER_BASE/api
ENV GROUPER_UI_HOME $GROUPER_BASE/ui
ENV GROUPER_WS_HOME $GROUPER_BASE/ws
ENV PATH $GROUPER_HOME/bin:$PATH

# Environment vairables for Bouncy Castle
ENV BCPROV_BASE http://bouncycastle.org/download
ENV BCPROV_JAR bcprov-jdk15on-156.jar

COPY install-grouper.sh /tmp/install-grouper.sh
RUN /tmp/install-grouper.sh \
    && rm /tmp/install-grouper.sh

WORKDIR $CATALINA_HOME

EXPOSE 8080
CMD ["catalina.sh", "run"]

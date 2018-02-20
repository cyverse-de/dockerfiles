FROM jeanblanchard/java:jdk-8
MAINTAINER Sarah Roberts <sarahr@cyverse.org>
ARG git_commit=unknown
LABEL org.iplantc.de.grouper.git-ref="$git_commit"

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/
ENV LEIN_BASE_URL=https://github.com/technomancy/leiningen/releases/download

WORKDIR /tmp

RUN apk add --update tar bash openssl && rm -rf /var/cache/apk/*

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && wget -q https://raw.githubusercontent.com/technomancy/leiningen/$LEIN_VERSION/bin/lein-pkg \
  && echo "Comparing lein-pkg checksum ..." \
  && echo "019faa5f91a463bf9742c3634ee32fb3db8c47f0 *lein-pkg" | sha1sum -c - \
  && mv lein-pkg $LEIN_INSTALL/lein \
  && chmod 0755 $LEIN_INSTALL/lein \
  && wget -q $LEIN_BASE_URL/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && mkdir -p /usr/share/java \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar

ENV PATH=$PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

# Install clojure 1.8.0 so users don't have to download it every time
RUN echo '(defproject dummy "" :dependencies [[org.clojure/clojure "1.8.0"]])' > project.clj \
  && lein deps && rm project.clj

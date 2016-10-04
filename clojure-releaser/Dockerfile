FROM clojure

RUN apt-get update -y && apt-get install -y gnupg-agent

RUN git config --global push.default simple

ADD start-up.sh /start-up.sh

CMD ["/start-up.sh"]
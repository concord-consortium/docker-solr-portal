FROM solr:5.3

ENV APP_HOME /opt/solr/rigse-solr-docker
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

CMD $APP_HOME/start-solr.sh

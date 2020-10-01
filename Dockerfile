FROM maven:3.6-jdk-8
MAINTAINER Nathan Walker <nathan@rylath.net>, Sean Óg Crudden <og.crudden@gmail.com>

ARG TRANSITCLOCK_PROPERTIES="config/transitclock.properties"

ENV TRANSITCLOCK_PROPERTIES ${TRANSITCLOCK_PROPERTIES}

RUN apt-get update \
	&& apt-get install -y postgresql-client \
	&& apt-get install -y git-core \
	&& apt-get install -y vim

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.43
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080


# Install json parser so we can read API key for CreateAPIKey output

RUN wget http://stedolan.github.io/jq/download/linux64/jq

RUN chmod +x ./jq

RUN cp jq /usr/bin/

WORKDIR /
RUN mkdir /usr/local/transitclock
RUN mkdir /usr/local/transitclock/db
RUN mkdir /usr/local/transitclock/config
RUN mkdir /usr/local/transitclock/logs
RUN mkdir /usr/local/transitclock/cache
RUN mkdir /usr/local/transitclock/data
RUN mkdir /usr/local/transitclock/test
RUN mkdir /usr/local/transitclock/test/config

WORKDIR /usr/local/transitclock

#RUN  curl -s https://api.github.com/repos/TheTransitClock/transitime/releases/latest | jq -r ".assets[].browser_download_url" | grep 'Core.jar\|api.war\|web.war' | xargs -L1 wget

ADD transitime/transitclockWebapp/target/web.war /usr/local/transitclock/
ADD transitime/transitclockApi/target/api.war /usr/local/transitclock/
ADD transitime/transitclock/target/transitclockCore-2.1.0-Core.jar /usr/local/transitclock/Core.jar

# Deploy API which talks to core using RMI calls.
RUN mv api.war  /usr/local/tomcat/webapps

# Deploy webapp which is a UI based on the API.
RUN mv web.war  /usr/local/tomcat/webapps

# Scripts required to start transiTime.
ADD bin/check_db_up.sh /usr/local/transitclock/bin/check_db_up.sh
ADD bin/generate_sql.sh /usr/local/transitclock/bin/generate_sql.sh
ADD bin/create_tables.sh /usr/local/transitclock/bin/create_tables.sh
ADD bin/create_api_key.sh /usr/local/transitclock/bin/create_api_key.sh
ADD bin/create_webagency.sh /usr/local/transitclock/bin/create_webagency.sh
ADD bin/import_gtfs.sh /usr/local/transitclock/bin/import_gtfs.sh
ADD bin/start_transitclock.sh /usr/local/transitclock/bin/start_transitclock.sh
ADD bin/get_api_key.sh /usr/local/transitclock/bin/get_api_key.sh
ADD bin/update_traveltimes.sh /usr/local/transitclock/bin/update_traveltimes.sh


# Handy utility to allow you connect directly to database
ADD bin/connect_to_db.sh /usr/local/transitclock/bin/connect_to_db.sh

ENV PATH="/usr/local/transitclock/bin:${PATH}"

# This is a way to copy in test data to run a regression test.

RUN \
	sed -i 's/\r//' /usr/local/transitclock/bin/*.sh &&\
 	chmod 777 /usr/local/transitclock/bin/*.sh

ADD config/postgres_hibernate.cfg.xml /usr/local/transitclock/config/hibernate.cfg.xml
ADD config/ehcache.xml /usr/local/transitclock/config/ehcache.xml
ADD config/logback.xml /usr/local/transitclock/config/logback.xml
ADD ${TRANSITCLOCK_PROPERTIES} /usr/local/transitclock/config/transitclock.properties

EXPOSE 8080

CMD ["tail -f /dev/null"]

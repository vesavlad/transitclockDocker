FROM maven:3.6-jdk-8

ARG AGENCYID="ro.stpt"
ARG AGENCYNAME="STPT"
ARG TRANSITCLOCK_PROPERTIES="config/transitclock.properties" 
ARG GTFS_URL="https://data.opentransport.ro/routing/gtfs/gtfs-timisoara.zip"
ARG GTFSRTVEHICLEPOSITIONS="https://api.opentransport.ro/realtime/vehicle-positions/tm"

ENV AGENCYID ${AGENCYID}
ENV AGENCYNAME ${AGENCYNAME}
ENV GTFS_URL ${GTFS_URL}
ENV GTFSRTVEHICLEPOSITIONS ${GTFSRTVEHICLEPOSITIONS}
ENV TRANSITCLOCK_PROPERTIES ${TRANSITCLOCK_PROPERTIES}

ENV TRANSITCLOCK_CORE /transitclock-core

RUN apt-get update && apt-get install -y postgresql-client git-core jq vim

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.43
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN mkdir -p "$CATALINA_HOME" && cd $CATALINA_HOME
WORKDIR $CATALINA_HOME

RUN set -x \
    && cd $CATALINA_HOME && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz*

EXPOSE 8080


# Install json parser so we can read API key for CreateAPIKey output
# RUN wget http://stedolan.github.io/jq/download/linux64/jq
# RUN chmod +x jq
# RUN mv jq /usr/bin/

RUN mkdir -p /usr/local/transitclock/db && \
    mkdir -p /usr/local/transitclock/config && \
    mkdir -p /usr/local/transitclock/logs && \
    mkdir -p /usr/local/transitclock/cache && \
    mkdir -p /usr/local/transitclock/data && \
    mkdir -p /usr/local/transitclock/test/config

WORKDIR /usr/local/transitclock

RUN  curl -s https://api.github.com/repos/TheTransitClock/transitime/releases/latest | jq -r ".assets[].browser_download_url" | grep 'Core.jar\|api.war\|web.war' | xargs -L1 wget

#ADD transitime/transitclockWebapp/target/web.war /usr/local/transitclock/
#ADD transitime/transitclockApi/target/api.war /usr/local/transitclock/
#ADD transitime/transitclock/target/Core.jar /usr/local/transitclock/

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
ADD bin/import_avl.sh /usr/local/transitclock/bin/import_avl.sh
ADD bin/process_avl.sh /usr/local/transitclock/bin/process_avl.sh
ADD bin/update_traveltimes.sh /usr/local/transitclock/bin/update_traveltimes.sh
ADD bin/set_config.sh /usr/local/transitclock/bin/set_config.sh

# Handy utility to allow you connect directly to database
ADD bin/connect_to_db.sh /usr/local/transitclock/bin/connect_to_db.sh

ENV PATH="/usr/local/transitclock/bin:${PATH}"

RUN \
    sed -i 's/\r//' /usr/local/transitclock/bin/*.sh && \
    chmod 777 /usr/local/transitclock/bin/*.sh

ADD config/postgres_hibernate.cfg.xml /usr/local/transitclock/config/hibernate.cfg.xml
ADD ${TRANSITCLOCK_PROPERTIES} /usr/local/transitclock/config/transitclock.properties

# This adds the transitime configs to test.
ADD config/test/* /usr/local/transitclock/config/test/

EXPOSE 8080

CMD ["start_transitclock.sh"]

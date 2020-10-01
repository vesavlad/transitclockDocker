#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Start TheTransitClock.'

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(get_api_key.sh)

# make it so we can also access as a system property in the JSP
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.apikey=$(get_api_key.sh)"

export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.db.dbUserName=$DATABASE_USER"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.db.dbPassword=$PGPASSWORD"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.db.dbName=$AGENCYNAME"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.core.agencyId=$AGENCYID"

echo JAVA_OPTS $JAVA_OPTS

/usr/local/tomcat/bin/startup.sh

java -Xss12m -Xms3g -Xmx5g -XX:MaxDirectMemorySize=16G \
  -Duser.timezone=PDT \
  -Dtransitclock.db.dbUserName=$DATABASE_USER \
  -Dtransitclock.db.dbPassword=$PGPASSWORD \
  -Dtransitclock.db.dbName=$AGENCYNAME \
  -Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT\
  -Dlogback.configurationFile=/usr/local/transitclock/config/logback.xml \
  -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties \
  -Dtransitclock.core.agencyId=$AGENCYID \
  -Dtransitclock.logging.dir=/usr/local/transitclock/logs/ \
  -jar /usr/local/transitclock/Core.jar > /usr/local/transitclock/logs/output.txt &

tail -f /dev/null

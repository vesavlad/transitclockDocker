#!/bin/bash
echo 'THETRANSITCLOCK DOCKER: Start TheTransitClock.'

# This is to substitute into config file the env values
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

echo '1. check db status'
check_db_up.sh > /usr/local/transitclock/logs/check_db_up.log 2>&1
echo '2. create tables'
create_tables.sh > /usr/local/transitclock/logs/create_tables.log 2>&1
echo '3. import gtfs'
import_gtfs.sh > /usr/local/transitclock/logs/import_gtfs.log 2>&1
echo '4. create api keys'
create_api_key.sh > /usr/local/transitclock/logs/create_api_key.log 2>&1
echo '5. create web agency'
create_webagency.sh > /usr/local/transitclock/logs/create_webagency.log 2>&1

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(get_api_key.sh)

# make it so we can also access as a system property in the JSP
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.apikey=$(get_api_key.sh)"

export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties"

echo JAVA_OPTS $JAVA_OPTS

bash /usr/local/tomcat/bin/startup.sh

java -Xss12m -Xms8g -Xmx12g -Duser.timezone=GMT+2 \
    -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties \
    -Dtransitclock.core.agencyId=$AGENCYID \
    -Dtransitclock.logging.dir=/usr/local/transitclock/logs/ \
    -jar /usr/local/transitclock/Core.jar > /usr/local/transitclock/logs/output.txt &

tail -f /usr/local/transitclock/logs/output.txt

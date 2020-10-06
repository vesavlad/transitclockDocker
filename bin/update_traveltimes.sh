#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Update travel times : '+$1+'==>'+$2+'.'

java -Xmx2048m -Xss12m \
  -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties \
  -Dtransitclock.db.dbUserName=$DATABASE_USER \
  -Dtransitclock.db.dbPassword=$PGPASSWORD \
  -Dtransitclock.db.dbName=$AGENCYNAME \
  -Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT \
  -Dtransitclock.core.agencyId=1 \
  -Dtransitclock.logging.dir=/usr/local/transitclock/logs/ \
  -cp /usr/local/transitclock/Core.jar \
  org.transitclock.applications.UpdateTravelTimes $1 $2

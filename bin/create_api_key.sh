#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create API key.'

java \
-Dtransitclock.core.agencyId=$AGENCYID \
-Dtransitclock.db.dbUserName=$DATABASE_USER \
-Dtransitclock.db.dbPassword=$PGPASSWORD \
-Dtransitclock.db.dbName=$AGENCYNAME \
-Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT \
-cp /usr/local/transitclock/Core.jar org.transitclock.applications.CreateAPIKey \
  -c "/usr/local/transitclock/config/transitclock.properties" \
  -d "foo" \
  -e "og.crudden@gmail.com" \
  -n "Sean Og Crudden" \
  -p "123456" \
  -u "http://www.transitclock.org"

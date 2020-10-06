#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create WebAgency.'
java \
  -Dtransitclock.db.dbName=$AGENCYNAME \
  -Dtransitclock.hibernate.configFile=/usr/local/transitclock/config/hibernate.cfg.xml \
  -Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT \
  -Dtransitclock.db.dbUserName=$DATABASE_USER\
  -Dtransitclock.db.dbPassword=$PGPASSWORD \
  -Dtransitclock.db.dbType=postgresql \
  -cp /usr/local/transitclock/Core.jar org.transitclock.db.webstructs.WebAgency \
  $AGENCYID 127.0.0.1 $AGENCYNAME postgresql $POSTGRES_PORT_5432_TCP_ADDR $DATABASE_USER $PGPASSWORD

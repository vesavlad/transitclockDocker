#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Import GTFS file.'
# This is to substitute into config file the env values.

java -Xmx4g \
	-Dtransitclock.core.agencyId=$AGENCYID \
	-Dtransitclock.db.dbUserName=$DATABASE_USER \
	-Dtransitclock.db.dbPassword=$PGPASSWORD \
	-Dtransitclock.db.dbName=$AGENCYNAME \
	-Dtransitclock.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT\
	-Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties \
	-Dtransitclock.logging.dir=/usr/local/transitclock/logs/ \
	-Dlogback.configurationFile=$TRANSITCLOCK_CORE/transitclock/src/main/resouces/logbackGtfs.xml \
	-cp /usr/local/transitclock/Core.jar org.transitclock.applications.GtfsFileProcessor \
	-gtfsUrl $GTFS_URL  \
	-storeNewRevs \
	-maxTravelTimeSegmentLength 100

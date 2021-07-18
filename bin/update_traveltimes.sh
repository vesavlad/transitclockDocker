#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Update travel times : '+$1+'==>'+$2+'.'

java -Xmx2048m -Xss12m -Dtransitclock.configFiles=/usr/local/transitclock/config/transitclock.properties -Dtransitclock.core.agencyId=1 -Dtransitclock.logging.dir=/usr/local/transitclock/logs/ -cp /usr/local/transitclock/Core.jar org.transitclock.applications.UpdateTravelTimes $1 $2

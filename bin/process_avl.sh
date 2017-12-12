#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Process test AVL.'
# This is to substitute into config file the env values. 
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;


psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-c "SELECT distinct time::date as thedate FROM public.avlreports order by thedate;"
	
# psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -d $AGENCYNAME -t -c "SELECT distinct time::date as mydate FROM public.avlreports order by mydate;"|xargs -I {} echo {}
	
	
# This will process AVL using the set of transitime config files in the test directory.
#find /usr/local/transitime/config/test/ -type f | sort -n | xargs -I {} java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles={} -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0 \;
wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-13.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Dnet.sf.ehcache.disabled=false -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 11-13-2017 11-13-2017

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-14.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig2.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Dnet.sf.ehcache.disabled=false -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig2.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 11-13-2017 11-14-2017

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-15.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig3.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Dnet.sf.ehcache.disabled=false -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig3.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 11-13-2017 11-15-2017

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-16.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Dnet.sf.ehcache.disabled=false -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 11-13-2017 11-16-2017

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-17.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Dnet.sf.ehcache.disabled=false -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 11-13-2017 11-17-2017

## RUN for another week without updates to travel times.
wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-20.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-21.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0


wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-22.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
2017-11-10.csv

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-23.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0

wget https://github.com/scascketta/CapMetrics/blob/master/data/vehicle_positions/2017-11-24.csv?raw=true -O /tmp/data.csv
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0



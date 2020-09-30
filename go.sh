export PGPASSWORD=$TRANSITCLOCK_DB_PASSWORD
export SERVERNAME=$TRANSITCLOCK_DOCKER_INSTANCE_NAME
export DATABASE=$TRANSITCLOCK_DATABASE_TCP_ADDR
export TRANSITCLOCK_PORT=$TRANSITCLOCK_WEB_PORT
export DATABASE_PORT=$TRANSITCLOCK_DATABASE_PORT

docker stop $SERVERNAME

docker rm $SERVERNAME

docker rmi transitclock-server

docker build --no-cache -t transitclock-server \
--build-arg TRANSITCLOCK_PROPERTIES="config/transitclock.properties" \
--build-arg AGENCYID="1" \
--build-arg AGENCYNAME="lametro" \
--build-arg GTFS_URL="https://transitfeeds.com/p/la-metro/184/latest/download" \
--build-arg GTFSRTVEHICLEPOSITIONS='https://www.ztm.poznanepl/pl/dla-deweloperow/getGtfsRtFile/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0ZXN0Mi56dG0ucG96bmFuLnBsIiwiY29kZSI6MSwibG9naW4iOiJtaFRvcm8iLCJ0aW1lc3RhbXAiOjE1MTM5NDQ4MTJ9.ND6_VN06FZxRfgVylJghAoKp4zZv6_yZVBu_1-yahlo&file=vehicle_positions.pb' .

#docker run --name $SERVERNAME --rm -e PGPASSWORD=$PGPASSWORD -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -v ~/logs:/usr/local/transitclock/logs/ transitclock-server check_db_up.sh

#docker run --name $SERVERNAME --rm -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -e POSTGRES_PORT_5432_TCP_PORT=$DATABASE_PORT -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_tables.sh

#docker run --name $SERVERNAME --rm -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -e POSTGRES_PORT_5432_TCP_PORT=$DATABASE_PORT -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server import_gtfs.sh

#docker run --name $SERVERNAME --rm -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -e POSTGRES_PORT_5432_TCP_PORT=$DATABASE_PORT -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_api_key.sh

#docker run --name $SERVERNAME --rm -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -e POSTGRES_PORT_5432_TCP_PORT=$DATABASE_PORT -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_webagency.sh

docker run --name $SERVERNAME --rm -e POSTGRES_PORT_5432_TCP_ADDR=$DATABASE -e POSTGRES_PORT_5432_TCP_PORT=$DATABASE_PORT -e PGPASSWORD=$PGPASSWORD  -v ~/logs:/usr/local/transitclock/logs/$SERVERNAME/ -v ~/ehcache:/usr/local/transitclock/cache/SERVERNAME/ -p $TRANSITCLOCK_PORT:8080 transitclock-server  start_transitclock.sh

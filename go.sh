export PGPASSWORD=transitclock

docker stop transitclock-db
docker stop transitclock-server-instance

docker rm transitclock-db
docker rm transitclock-server-instance

docker rmi transitclock-server

docker build --no-cache -t transitclock-server \
--build-arg TRANSITCLOCK_PROPERTIES="config/transitclock.properties" \
--build-arg AGENCYID="1" \
--build-arg AGENCYNAME="MPK" \
--build-arg GTFS_URL="http://www.iplaner.pl/mpk.zip" \
--build-arg GTFSRTVEHICLEPOSITIONS='https://www.ztm.poznanepl/pl/dla-deweloperow/getGtfsRtFile/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0ZXN0Mi56dG0ucG96bmFuLnBsIiwiY29kZSI6MSwibG9naW4iOiJtaFRvcm8iLCJ0aW1lc3RhbXAiOjE1MTM5NDQ4MTJ9.ND6_VN06FZxRfgVylJghAoKp4zZv6_yZVBu_1-yahlo&file=vehicle_positions.pb' .

docker run --name transitclock-db -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres:9.6.3

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server check_db_up.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_tables.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server import_gtfs.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_api_key.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD -v ~/logs:/usr/local/transitclock/logs/ transitclock-server create_webagency.sh

#docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./import_avl.sh

#docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./process_avl.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD  -v ~/logs:/usr/local/transitclock/logs/ -v ~/ehcache:/usr/local/transitclock/cache/ -p 8080:8080 transitclock-server  start_transitclock.sh

export PGPASSWORD=transitime
export AGENCYNAME=WEXFORD
export AGENCYID=1
export GTFS_URL="http://www.transportforireland.ie/transitData/google_transit_wexfordbus.zip"
export GTFSRTVEHICLEPOSITIONS="http://nosetasusemodule:8088/vehicle-positions"

docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

docker build --no-cache -t transitime-server .

docker run --name transitime-db -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres -p 5432:5432

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./check_db_up.sh

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_tables.sh

docker run  --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -e GTFS_URL=$GTFS_URL transitime-server ./import_gtfs.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_api_key.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_webagency.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e AGENCYID=$AGENCYID -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -e GTFSRTVEHICLEPOSITIONS=$GTFSRTVEHICLEPOSITIONS -e GTFS_URL=$GTFS_URL -p 8080:8080 transitime-server  ./start_transitime.sh

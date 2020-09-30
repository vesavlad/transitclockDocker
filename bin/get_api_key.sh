psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U lametro -d $AGENCYNAME -t -c "SELECT applicationkey from apikeys;"|xargs

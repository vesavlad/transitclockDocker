psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U $DATABASE_USER -d $AGENCYNAME -t -c "SELECT applicationkey from apikeys;"|xargs

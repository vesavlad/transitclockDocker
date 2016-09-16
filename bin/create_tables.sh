#!/usr/bin/env bash
java -jar $TRANSITIMECORE/transitime/target/SchemaGenerator.jar -p org.transitime.db.structs -o /usr/local/transitime/db/
java -jar $TRANSITIMECORE/transitime/target/SchemaGenerator.jar -p org.transitime.db.webstructs -o /usr/local/transitime/db/
createdb -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres $AGENCYNAME
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-f /usr/local/transitime/db/ddl_postgres_org_transitime_db_structs.sql
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-f /usr/local/transitime/db/ddl_postgres_org_transitime_db_webstructs.sql

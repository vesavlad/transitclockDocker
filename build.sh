cd transitime

mvn install -DskipTests

cd ..

docker build --no-cache -t transitclock-server \
--build-arg TRANSITCLOCK_PROPERTIES="config/transitclock.properties" \
.

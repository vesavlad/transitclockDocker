# transitclockDocker

Things to make The Transit Clock go:

- Ubuntu
- sudo apt-get install git
- sudo apt-get install docker.io
- git clone https://github.com/TheTransitClock/transitclockDocker.git
- Configure agency details in the go.sh script. Here you set the agency name, agency id** (as in GTFS feed), GTFS feed location and GTFS-realtime vehicle location url.
- ./go.sh

**AgencyId is optional in GTFS so just set to 1 if none specified.

The go script will build the transit clock container (takes a long time), start the postgres db, create the tables,
push the gtfs data into the db, create an API key and then start the api service and web user interface service. 

To view web interface
```
http://127.0.0.1:8080/web
```
To view api
```
http://127.0.0.1:8080/api
```
These work as the docker installer maps the container port 8080 to the same port on the host machine.



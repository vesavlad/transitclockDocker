#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create API key.'

java -cp /usr/local/transitclock/Core.jar org.transitclock.applications.CreateAPIKey \
    --config "/usr/local/transitclock/config/transitclock.properties" \
    --description "foo" \
    --email "og.crudden@gmail.com" \
    --name "Sean Og Crudden" \
    --phone "123456" \
    --url "http://www.transitclock.org"
